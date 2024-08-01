class Config:
    SQL_SERVER = 'DESKTOP-CQ8T8UT'
    DATABASE = 'Guiatu1'
    DRIVER = 'ODBC Driver 17 for SQL Server'
    CONNECTION_STRING = f'DRIVER={DRIVER};SERVER={SQL_SERVER};DATABASE={DATABASE};Trusted_Connection=yes;'
    SECRET_KEY = 'your_secret_key'
