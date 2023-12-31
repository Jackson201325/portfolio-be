# frozen_string_literal: true

module ApplicationHelper
  def navigation_items
    [
      { body: "Listings", href: listings_path },
      { body: "My Listing", href: host_listings_path },
      { body: "Reservations", href: reservations_path }
    ]
  end

  def navigation_class(path)
    if current_page?(path)
      "bg-gray-900 text-white rounded-md px-3 py-2 text-sm font-medium"
    else
      "text-gray-300 hover:bg-gray-700 hover:text-white rounded-md px-3 py-2 text-sm font-medium"
    end
  end

  def navigation_aria(path)
    if current_page?(path)
      "page"
    else
      "false"
    end
  end

  def mobile_navigation_class(path)
    if current_page?(path)
      "bg-gray-900 text-white block rounded-md px-3 py-2 text-base font-medium"
    else
      "text-gray-300 hover:bg-gray-700 hover:text-white block rounded-md px-3 py-2 text-base font-medium"
    end
  end
end
