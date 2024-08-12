from flask import Flask, render_template, request, redirect, url_for, session, flash, jsonify
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash
#from config import Config
from datetime import datetime

app = Flask(__name__)
<<<<<<< Updated upstream:App.py
app.config.from_object(Config)  # Carga la configuración desde la clase Config

def get_db_connection():
    connection = pyodbc.connect(app.config['CONNECTION_STRING'])
    return connection
=======
#app.config.from_object(Config)  # Cargar la configuración desde la clase Config


def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host='mysql',  # Cambiado de MYSQL_HOST a host
            user='root',       # Cambiado de USERNAME a user
            password='root',
            database='Guiatu2'  # Cambiado de DATABASE a database
        )
        return connection
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        raise


>>>>>>> Stashed changes:app/App.py

@app.route('/')
def index():
    return render_template('index.html')


@app.route('/post')
def post():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT id_destino, nombre_destino FROM Destinos')
    places = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('postDemo.html', places=places)


@app.route('/hoteles', methods=['GET'])
def hoteles():
    id_destino = request.args.get('id_destino', type=int)
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        'SELECT nombre_hotel, descripcion, url_pagina, url_img, dato1, dato2 FROM Hoteles WHERE id_destino = %s',
        (id_destino,))
    hoteles = cursor.fetchall()
    cursor.close()
    conn.close()
    hoteles_list = [{
        'nombre_hotel': hotel['nombre_hotel'],
        'descripcion': hotel['descripcion'],
        'url_pagina': hotel['url_pagina'],
        'url_img': hotel['url_img'],
        'dato1': hotel['dato1'],
        'dato2': hotel['dato2']
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
<<<<<<< Updated upstream:App.py
    return render_template('about.html')
=======
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT id_destino, nombre_destino FROM Destinos")
    destinos = cursor.fetchall()
    connection.close()

    destinos_list = [
        {
            "id_destino": row['id_destino'],
            "nombre_destino": row['nombre_destino']
        }
        for row in destinos
    ]
    return render_template('about.html', destinos=destinos_list)

>>>>>>> Stashed changes:app/App.py

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        correo = request.form['correo']
        password = request.form['password']
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)
        cursor.execute("SELECT * FROM Usuarios WHERE correo = %s", (correo,))
        user = cursor.fetchone()
        connection.close()

        if user:
            if check_password_hash(user['contrasena'], password):
                session['user_id'] = user['id_usuario']
                session['user_name'] = user['nombre']
                connection = get_db_connection()
                cursor = connection.cursor()
                cursor.execute("INSERT INTO Login (id_usuario, login_date) VALUES (%s, %s)",
                               (user['id_usuario'], datetime.now()))
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
        contrasena = request.form['contrasena']
        hashed_password = generate_password_hash(contrasena, method='pbkdf2:sha256')

        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute(
            "INSERT INTO Usuarios (nombre, apellido, correo, contrasena, fecha_registro) VALUES (%s, %s, %s, %s, NOW())",
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
    cursor = connection.cursor(dictionary=True)
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
            "id": row['id_destino'],
            "name": row['nombre_destino'],
            "description": row['descripcion'],
            "image": images.get(row['id_destino'], "placeholder.jpg")
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
        VALUES (%s, %s, %s, %s, %s)
    """, (id_usuario, id_destino, comment, rating, fecha_opinion))
    connection.commit()
    connection.close()

    return jsonify({"status": "success"})


@app.route('/get_comments/<int:id_destino>', methods=['GET'])
def get_comments(id_destino):
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute("""
        SELECT Opiniones.id_opinion, Opiniones.comentario, Opiniones.calificacion, Opiniones.fecha_opinion, Usuarios.nombre
        FROM Opiniones
        JOIN Usuarios ON Opiniones.id_usuario = Usuarios.id_usuario
        WHERE Opiniones.id_destino = %s
    """, (id_destino,))
    comments = cursor.fetchall()
    connection.close()

    comments_list = [
        {
            "id_opinion": row['id_opinion'],
            "comment": row['comentario'],
            "rating": row['calificacion'],
            "date": row['fecha_opinion'],
            "user_name": row['nombre']
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

    cursor.execute("SELECT id_usuario FROM Opiniones WHERE id_opinion = %s", (id_opinion,))
    comment_owner = cursor.fetchone()
    if not comment_owner or comment_owner['id_usuario'] != session['user_id']:
        connection.close()
        return jsonify({"status": "error", "message": "You can only edit your own comments"}), 403

    cursor.execute("""
        UPDATE Opiniones
        SET comentario = %s
        WHERE id_opinion = %s
    """, (new_comment, id_opinion))
    connection.commit()
    connection.close()

    return jsonify({"status": "success"})


<<<<<<< Updated upstream:App.py
=======
@app.route('/get_activities/<int:id_destino>', methods=['GET'])
def get_activities(id_destino):
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute("""
        SELECT id_actividad, nombre_actividad, descripcion, duracion, costos
        FROM Actividades
        WHERE id_destino = %s
    """, (id_destino,))
    activities = cursor.fetchall()
    connection.close()

    images = {
        1: "Bernal.webp",
        2: "tallerBernal.png",
        3: "vinelloBernal.png",
        4: "AguaTermalesSanJoaquin.png",
        5: "LuciernagasSanJoaquin.jpg",
        6: "ReforestacionSanJoaquin.png",
        7: "AveSierraGorda.jpg",
        8: "sierraGorda.png",
        9: "EcoturismoSierra.png",
        10: "LimpiezaSenderoChuveje.png",
        11: "ConservacionAguaChuveje.png",
        12: "CampamentoChuveje.png"
    }

    activities_list = [
        {
            "id_actividad": row['id_actividad'],
            "nombre_actividad": row['nombre_actividad'],
            "descripcion": row['descripcion'],
            "duracion": row['duracion'],
            "costos": row['costos'],
            "image": url_for('static', filename='assets/' + images.get(row['id_actividad'], "placeholder.jpg"))
        }
        for row in activities
    ]
    return jsonify(activities_list)


>>>>>>> Stashed changes:app/App.py
@app.errorhandler(404)
def paginanotfound(e):
    return 'Revisa tu sintaxis: No encontré nada'


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
