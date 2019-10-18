module ApplicationHelper
  def cart_count_over_one
    return total_cart_items if total_cart_items > 0
  end

  def total_cart_items
    if @cart
      total = @cart.line_items.map(&:quantity).sum
      return total if total > 0
    else 
      return 
    end

  end
end
