from flask import Blueprint, render_template, request, redirect, url_for
from models import Book
from app import db

main_bp = Blueprint('main', __name__)

@main_bp.route('/')
def index():
    books = Book.query.all()
    return render_template('home.html', books=books)

@main_bp.route('/add', methods=['GET', 'POST'])
def add_book():
    if request.method == 'POST':
        title = request.form.get('title')
        author = request.form.get('author')
        year = request.form.get('year')
        new_book = Book(title=title, author=author, year=year if year else None)
        db.session.add(new_book)
        db.session.commit()
        return redirect(url_for('main.index'))
    return render_template('add_book.html')

@main_bp.route('/view')
def view_books():
    books = Book.query.all()
    return render_template('view_books.html', books=books)
