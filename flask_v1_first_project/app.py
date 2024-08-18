from flask import Flask
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database.db'
    db.init_app(app)

    # Import and register the blueprint here
    from routes import main_bp
    app.register_blueprint(main_bp, url_prefix='/')

    with app.app_context():
        db.create_all()

    return app
