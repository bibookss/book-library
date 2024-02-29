#! /bin/bash

function init_db() {
  if [ -f books.txt ] && [ -f quotes.txt ]; then
    return
  fi

  echo 'Id|Title|Author|Genre|HasRead' > books.txt
  echo 'Id|BookId|Quote' > quotes.txt
}

function add_book() {
  read -p "Enter title: " title
  read -p "Enter author: " author
  read -p "Enter genre: " genre
  read -p "Has read? (yes/no): " has_read

  # Generate an id
  id=$(cat books.txt | wc -l | sed -e 's/^[ \t]*//' -e 's/[ \t]*$//')
  echo "$id|$title|$author|$genre|$has_read" >> books.txt
  echo "Book is added!"
}

function list_books() {
  column -s '|' -t books.txt 
}

function search_books() {
  read -p "Enter search: " query

  # Echo the header and format it using column
  echo "Id|Title|Author|Genre|HasRead" | column -s '|' -t

  # Filter books by author and format the output
  grep -i "$query" books.txt | column -s '|' -t 
}

function get_unread_books() {
  echo "Id|Title|Author|Genre|HasRead" | column -s '|' -t
  awk -F '|' '$5 ~ /no/' books.txt | column -s '|' -t
}

function get_read_books() {
  echo "Id|Title|Author|Genre|HasRead" | column -s '|' -t
  awk -F '|' '$5 ~ /yes/' books.txt | column -s '|' -t
}

function update_book() {
  read -p "Enter book id: " id
  read -p "Enter title: " title
  read -p "Enter author: " author
  read -p "Enter genre: " genre
  read -p "Has read? (yes/no): " has_read

  # Update the book
  # Find line number of the book id
  awk -v id=$id -F '|' '$1 == id { print NR; exit}' books.txt | xargs -I {} sed -i '' -e "{}s/.*/$id|$title|$author|$genre|$has_read/" books.txt
  echo "Book is updated!"
}

function add_quote() {
  echo "Adding quote..."
  # echo "$2,$3,$4" >> quotes.csv
  # echo "Quote is added!"
}

function list_quotes() {
  echo "Listing quotes..."
  cat quotes.csv
}

function help() {
  echo "Usage: book.sh <command>"
  echo "Commands:"
  echo "  add_book"
  echo "  list_books"
  echo "  search_books"
  echo "  get_unread_books"
  echo "  get_read_books"
  echo "  update_book"
  echo "  delete_book"
  echo "  add_quote"
  echo "  list_quotes"
  echo "  get_quotes_by_book"
  echo "  update_quote"
  echo "  delete_quote"
}

function main() {
  init_db

  case $1 in
    "add_book")
      add_book
      ;;
    "search_books")
      search_books
      ;;
    "get_unread_books")
      get_unread_books
      ;;
    "get_read_books")
      get_read_books
      ;;
    "update_book")
      update_book
      ;;
    "delete_book")
      delete_book
      ;;
    "list_books")
      list_books
      ;;
    "add_quote")
      add_quote 
      ;;
    "list_quotes")
      list_quotes
      ;;
    "search_quotes")
      search_quotes "${@:2}"
      ;;
    "update_quote")
      update_quote "${@:2}"
      ;;
    "delete_quote")
      delete_quote "${@:2}"
      ;;
    *)
      help
      ;;
  esac
}

main $@