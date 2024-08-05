from flask import Flask, render_template, request, redirect, url_for, session, flash, jsonify
import pyodbc
from werkzeug.security import generate_password_hash, check_password_hash
from config import Config
from datetime import datetime

app = Flask(__name__)
app.config.from_object(Config)  # Carga la configuración desde la clase Config

def get_db_connection():
    connection = pyodbc.connect(app.config['CONNECTION_STRING'])
    return connection

@app.route('/')
def index():
    return render_template('index.html')


@app.route('/post')
def post():
    conn = get_db_connection()  # Usa la función get_db_connection
    cursor = conn.cursor()
    cursor.execute('SELECT id_destino, nombre_destino FROM Destinos')
    places = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('postDemo.html', places=places)

@app.route('/hoteles', methods=['GET'])
def hoteles():
    id_destino = request.args.get('id_destino', type=int)
    conn = get_db_connection()  # Usa la función get_db_connection
    cursor = conn.cursor()
    cursor.execute('SELECT nombre_hotel, descripcion, url_pagina, url_img, dato1, dato2 FROM Hoteles WHERE id_destino = ?', (id_destino,))
    hoteles = cursor.fetchall()
    cursor.close()
    conn.close()
    hoteles_list = [{
        'nombre_hotel': hotel[0],
        'descripcion': hotel[1],
        'url_pagina': hotel[2],
        'url_img': hotel[3],
        'dato1': hotel[4],
        'dato2': hotel[5]
    } for hotel in hoteles]
    return jsonify(hoteles_list)


@app.route('/contact')
def contact():
    return render_template('contact.html')


@app.route('/comentarios')
def comentarios():
    return render_template('comentarios.html')


@app.route('/about')
def about():
    return render_template('about.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        correo = request.form['correo']
        password = request.form['password']
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM Usuarios WHERE correo = ?", (correo,))
        user = cursor.fetchone()
        connection.close()

        if user:
            # Para depuración: imprimir el hash de la contraseña y la entrada del usuario
            print(f"Hash en la base de datos: {user[4]}")
            print(f"Contraseña ingresada: {password}")

            if check_password_hash(user[4], password):
                session['user_id'] = user[0]
                session['user_name'] = user[1]
                # Registrar la fecha y hora de inicio de sesión
                connection = get_db_connection()
                cursor = connection.cursor()
                cursor.execute("INSERT INTO Login (id_usuario, login_date) VALUES (?, ?)", (user[0], datetime.now()))
                connection.commit()
                connection.close()
                return redirect(url_for('index'))
            else:
                flash('Contraseña incorrecta')
        else:
            flash('Correo no encontrado')

    return render_template('login.html')


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        nombre = request.form['nombre']
        apellido = request.form['apellido']
        correo = request.form['correo']
        contraseña = request.form['contraseña']
        hashed_password = generate_password_hash(contraseña, method='pbkdf2:sha256')

        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute(
            "INSERT INTO Usuarios (nombre, apellido, correo, contraseña, fecha_registro) VALUES (?, ?, ?, ?, GETDATE())",
            (nombre, apellido, correo, hashed_password))
        connection.commit()
        connection.close()
        flash('Registro exitoso. Ahora puedes iniciar sesión.')
        return redirect(url_for('login'))
    return render_template('register.html')


@app.route('/logout')
def logout():
    session.pop('user_id', None)
    session.pop('user_name', None)
    return redirect(url_for('index'))


@app.route('/get_destinations', methods=['GET'])
def get_destinations():
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT id_destino, nombre_destino, descripcion FROM Destinos")
    destinos = cursor.fetchall()

    images = {
        1: "bernal1.jpg",
        5: "sierra_gorda1.jpg",
        6: "chuveje1.jpg",
        7: "termas1.jpg"
        # Agrega más mapeos según sea necesario
    }

    destinations_list = [
        {
            "id": row[0],
            "name": row[1],
            "description": row[2],
            "image": images.get(row[0], "placeholder.jpg")  # Placeholder por defecto
        }
        for row in destinos]
    return jsonify(destinations_list)


@app.route('/submit_comment', methods=['POST'])
def submit_comment():
    data = request.json
    id_destino = data.get('id_destino')
    comment = data.get('comment')
    rating = data.get('rating')

    if not id_destino or not comment or not rating:
        return jsonify({"status": "error", "message": "All fields are required"}), 400

    if 'user_id' not in session:
        return jsonify({"status": "error", "message": "User not authenticated"}), 401

    id_usuario = session['user_id']
    fecha_opinion = datetime.now().strftime('%Y-%m-%d')

    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("""
        INSERT INTO Opiniones (id_usuario, id_destino, comentario, calificacion, fecha_opinion)
        VALUES (?, ?, ?, ?, ?)
    """, (id_usuario, id_destino, comment, rating, fecha_opinion))
    connection.commit()

    return jsonify({"status": "success"})


@app.route('/get_comments/<int:id_destino>', methods=['GET'])
def get_comments(id_destino):
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("""
        SELECT Opiniones.id_opinion, Opiniones.comentario, Opiniones.calificacion, Opiniones.fecha_opinion, Usuarios.nombre
        FROM Opiniones
        JOIN Usuarios ON Opiniones.id_usuario = Usuarios.id_usuario
        WHERE Opiniones.id_destino = ?
    """, (id_destino,))
    comments = cursor.fetchall()
    connection.close()

    comments_list = [
        {
            "id_opinion": row[0],
            "comment": row[1],
            "rating": row[2],
            "date": row[3],
            "user_name": row[4]
        }
        for row in comments
    ]
    return jsonify(comments_list)


@app.route('/edit_comment', methods=['POST'])
def edit_comment():
    data = request.json
    id_opinion = data.get('id_opinion')
    new_comment = data.get('comment')

    if not id_opinion or not new_comment:
        return jsonify({"status": "error", "message": "All fields are required"}), 400

    if 'user_id' not in session:
        return jsonify({"status": "error", "message": "User not authenticated"}), 401

    connection = get_db_connection()
    cursor = connection.cursor()

    # Check if the comment belongs to the logged-in user
    cursor.execute("SELECT id_usuario FROM Opiniones WHERE id_opinion = ?", (id_opinion,))
    comment_owner = cursor.fetchone()
    if not comment_owner or comment_owner[0] != session['user_id']:
        connection.close()
        return jsonify({"status": "error", "message": "You can only edit your own comments"}), 403

    # Update the comment
    cursor.execute("""
        UPDATE Opiniones
        SET comentario = ?
        WHERE id_opinion = ?
    """, (new_comment, id_opinion))
    connection.commit()
    connection.close()

    return jsonify({"status": "success"})


@app.errorhandler(404)
def paginanotfound(e):
    return 'Revisa tu sintaxis: No encontré nada'

if __name__ == '__main__':
    app.run(port=5000, debug=True)