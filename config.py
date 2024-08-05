class Config:
    SQL_SERVER = 'PC-LOT'
    DATABASE = 'Guiatu2'
    DRIVER = 'SQL Server'
    CONNECTION_STRING = f'DRIVER={DRIVER};SERVER={SQL_SERVER};DATABASE={DATABASE};Trusted_Connection=yes;'
    SECRET_KEY = 'your_secret_key'