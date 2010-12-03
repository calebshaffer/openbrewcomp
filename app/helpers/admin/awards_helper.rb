# -*- coding: utf-8 -*-

module Admin::AwardsHelper

  def point_qualifier_column(record)
    record.point_qualifier? ? "Yes" : "No"
  end

  def styles_column(record)
    if record.styles.blank?
      '<b>Add Styles</b>'
    else
      num_to_show = 3
      styles = sorted_styles(record).first(num_to_show+1).map(&:to_label)
      styles[num_to_show] = '…' if styles.length == num_to_show+1  # replace the Nth value with a horizontal ellipsis (U2026)
      h(styles.join(', '))
    end
  end

  def styles_show_column(record)
    return '-' if record.styles.blank?
    h(sorted_styles(record).map(&:to_label).join(', '))
  end

  def category_form_column(record, input_name)
    categories = Category.all(:order => 'position').map {|c| [ c.name, c.id ]}
    select :record, :category_id, categories,
           { :prompt => '- Select a category -' },
           { :name => input_name + '[id]' }
  end

  private

    def sorted_styles(record)
      record.styles.sort_by{ |s| [ s.bjcp_category, s.bjcp_subcategory ] }
    end

end
