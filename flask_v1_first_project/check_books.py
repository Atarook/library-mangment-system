from app import create_app, db
from models import Book

app = create_app()

def check_books():
    with app.app_context():
        # Query all books from the database
        books = Book.query.all()
        # Print details of each book
        for book in books:
            print(f'Title: {book.title}, Author: {book.author}, Year: {book.year}')

if __name__ == "__main__":
    check_books()
