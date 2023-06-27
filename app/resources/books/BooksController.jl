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

function billgatesbooks()
  html(:books, :billgatesbooks, books = all(Book))
end

module API

using ..BooksController
using Genie.Renderer.Json
using SearchLight
using RealTimeStockSystemDockerModel.Books

function billgatesbooks()
  json(:books, :billgatesbooks, books = all(Book))
end

end

end