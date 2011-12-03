class UnoServer
  def initialize()
    @cards = create_cards.shuffle
    @_cards = []
  end

  def create_cards
    cards = []
    
    %w(blue red yellow green).each do |color|
      cards.push color + 0.to_s
      (1..9).each do |n|
        2.times { cards.push color + n.to_s }
      end
    end
    
    %w(skip reverse draw2).each do |name|
      2.times { cards.push name }
    end
    
    %w(wild wilddraw4).each do |name|
      4.times { cards.push name }
    end

    cards
  end

  def draw
    @cards.shift
  end

  def throw(card)
    @_cards.push card
  end

  def reset
    @cards += @_cards
    @_cards = []
    @cards.shuffle!
  end
end

class UnoClient
  def initialize(server)
    @server = server
    @cards = []
  end

  def draw
    @cards << @server.draw
  end
  
  def throw(i)
    @server.throw @cards.delete_at(i)
  end
  
  def show
    @cards.each_with_index do |e, i|
      print i, ": ", e, "\n"
    end
  end

  def reset
    @cards = []
  end
end

if ARGV.delete 'server'
  require 'drb'
  uri = ARGV.shift
  DRb.start_service(uri, UnoServer.new)
  puts DRb.uri
  sleep
else
  require 'drb/drb'
end
