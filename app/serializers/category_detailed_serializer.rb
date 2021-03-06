class CategoryDetailedSerializer < BasicCategorySerializer

  attributes :topic_count,
             :post_count,
             :topics_day,
             :topics_week,
             :topics_month,
             :topics_year,
             :description_excerpt,
             :is_uncategorized,
             :subcategory_ids

  def is_uncategorized
    object.id == SiteSetting.uncategorized_category_id
  end

  def include_is_uncategorized?
    is_uncategorized
  end

  def description_excerpt
    PrettyText.excerpt(description, 300) if description
  end

  def include_subcategory_ids?
    subcategory_ids.present?
  end

  def topics_day
    count_with_subcategories(:topics_day)
  end

  def topics_week
    count_with_subcategories(:topics_week)
  end

  def topics_month
    count_with_subcategories(:topics_month)
  end

  def topics_year
    count_with_subcategories(:topics_year)
  end

  def count_with_subcategories(method)
    count = object.send(method) || 0
    object.subcategories.each do |category|
      count += (category.send(method) || 0)
    end
    count
  end

end
