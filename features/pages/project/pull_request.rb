class DiffSection < SitePrism::Section
  element :diff_stat, "span.diffstat"
  element :file_name, "span.js-selectable-text"
end

class PullRequest < SitePrism::Page
  set_url "/{user}/{repo}/pull/{number}"

  sections :diffs, DiffSection, ".file"

  def files_count
    Integer find("#files_tab_counter").text
  end

  def tab(name)
    # apparently element:contains(inntertext) is deprecated in CSS3
    # capybara will no longer accept this as a selector so forced to
    # go with xpath query combined with hackish css selector.
    tab_navigation = find(".tabnav-tabs:first-child")

    # query inner text of tab. need contains due to element
    # containing additional text following tab we're searching for.
    # i.e. "File Changed 1" # instead of simply "Files Changed".
    #
    # starts-with fails as element has a span just before text that matches the name of our tab.
    #
    # it is also recommended to use '.' when referring to element's inner text instead of text().
    # see http://stackoverflow.com/a/17345999
    tab_navigation.find(:xpath, ".//li/a[contains(., '#{name}')]")
  end

  def files_changed_count
    find("#toc .explain :nth-child(2)").text
  end
end
