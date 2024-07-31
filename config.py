class Config:
    SQL_SERVER = 'DESKTOP-U16RP4E\\SQLEXPRESS'
    DATABASE = 'Guiatu1'
    DRIVER = 'ODBC Driver 17 for SQL Server'
    CONNECTION_STRING = f'DRIVER={DRIVER};SERVER={SQL_SERVER};DATABASE={DATABASE};Trusted_Connection=yes;'
    SECRET_KEY = 'your_secret_key'
