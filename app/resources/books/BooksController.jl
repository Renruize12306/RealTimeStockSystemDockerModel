# # # app/resources/books/BooksController.jl
# # module BooksController

# # struct Book
# #   title::String
# #   author::String
# # end

# # const BillGatesBooks = Book[
# #   Book("The Best We Could Do", "Thi Bui"),
# #   Book("Evicted: Poverty and Profit in the American City", "Matthew Desmond"),
# #   Book("Believe Me: A Memoir of Love, Death, and Jazz Chickens", "Eddie Izzard"),
# #   Book("The Sympathizer", "Viet Thanh Nguyen"),
# #   Book("Energy and Civilization, A History", "Vaclav Smil")
# # ]

# # function billgatesbooks()
# #   "
# #   <h1>Bill Gates' list of recommended books</h1>
# #   <ul>
# #     $(["<li>$(book.title) by $(book.author)</li>" for book in BillGatesBooks]...)
# #   </ul>
# #   "
# # end

# # end

# # BooksController.jl
# module BooksController

# using Genie.Renderer.Html

# struct Book
#   title::String
#   author::String
# end

# const BillGatesBooks = Book[
#   Book("The Best We Could Do", "Thi Bui"),
#   Book("Evicted: Poverty and Profit in the American City", "Matthew Desmond"),
#   Book("Believe Me: A Memoir of Love, Death, and Jazz Chickens", "Eddie Izzard"),
#   Book("The Sympathizer!", "Viet Thanh Nguyen"),
#   Book("Energy and Civilization, A History", "Vaclav Smil")
# ]

# function billgatesbooks()
#   html(:books, :billgatesbooks, layout = :admin, books = BillGatesBooks)
# end


# module API

# using ..BooksController
# using Genie.Renderer.Json

# # function billgatesbooks()
# #   json(BooksController.BillGatesBooks)
# # end
# function billgatesbooks()
#   json(:books, :billgatesbooks, books = BooksController.BillGatesBooks)
# end

# end

# end

# BooksController.jl
module BooksController

using Genie.Renderer.Html
using SearchLight
using RealTimeStockSystemDockerModel.Books

function billgatesbooks1()
  html(:books, :billgatesbooks1, books = all(Book))
end

module API

using ..BooksController
using Genie.Renderer.Json
using SearchLight
using RealTimeStockSystemDockerModel.Books

function billgatesbooks_fun()
  #=
  in these cases, you can think of them as "things with a name". in other languages, 
  you would probably use enumerations or constants for this. they offer nothing else 
    than you can check for equality, like

  f(a) = a == :big ? 1000 : a == :small ? 10 : error("dunno what is $a")

  f(:big)    # -> 1000
  f(:small)  # -> 10
  this construct is also used heavily in metaprogramming, but that's for another day.

  =#
  # books is the resource locator app/resources/books/views/billgatesbooks_view.json.jl
  json(:books, :billgatesbooks_view, books = all(Book))
end

end

end