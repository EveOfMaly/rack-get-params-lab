class Application

  @@items = ["Apples","Carrots","Pears"] #class variable with list of items availble 
  @@cart = []  #cart array that starts empty

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)



   

    if req.path.match(/items/) #if the route is /items write the items 
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/) #if the route is /search give response for searches that are from @@items.
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/) #creates the /cart route returns empty message ife empty or returns all items in cart. 
      if @@cart.size == 0 
        resp.write "Your cart is empty"
      else
        @@cart.each do |cart|
          resp.write "#{cart}\n"
        end
      end
    elsif req.path.match(/add/)
      search_term = req.params["item"] #takes in a get param with the key item
      resp.write add_item(search_term) #if search result is an item from the item array add item to the cart else message
    else
      resp.write "Path Not Found"
      resp.status = 404
    end

    resp.finish
  end

  def add_item(search_term)
    if @@items.include?(search_term)
      @@cart << search_term 
      return "added #{search_term}"
    else
      return "We don't have that item"
    end
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
