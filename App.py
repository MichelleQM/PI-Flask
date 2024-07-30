from flask import Flask, render_template, request, redirect, url_for, session, flash
import pyodbc
from werkzeug.security import generate_password_hash, check_password_hash
from config import Config
from datetime import datetime

app = Flask(__name__)
app.config['SECRET_KEY'] = Config.SECRET_KEY

def get_db_connection():
    connection = pyodbc.connect(Config.CONNECTION_STRING)
    return connection

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/post')
def post():
    return render_template('post.html')

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

@app.errorhandler(404)
def paginanotfound(e):
    return 'Revisa tu sintaxis: No encontré nada'

if __name__ == '__main__':
    app.run(port=5000, debug=True)