module TemplateHelper
  def sanitize_opening_tags(opening_tags)
    self_closing_tags = ["<%>", "<%=>", "<area>", "<base>", "<br>", "<col>", "<command>", "<!DOCTYPE>", "<embed>", "<hr>", "<img>", "<input>", "<keygen>", "<link>", "<meta>", "<param>", "<source>", "<track>", "<wbr>"]

    opening_tags = opening_tags.map { |tag|
      if tag.include? " "
        tag.squish.partition(" ").first << ">"
      else
        tag
      end
    }

    opening_tags - self_closing_tags
  end

  def sanitize_closing_tags(closing_tags)
    closing_tags.map { |tag|
      if tag.include? "\/"
        tag.squish.tr('\/', "")
      else
        tag
      end
    }
  end

  def validate_closing_tags_exist(file_content)
    opening_regex = /<[^\/](?:"[^"]*"['"]*|'[^']*'['"]*|[^'">])*>/
    closing_regex = /<\/(?:"[^"]*"['"]*|'[^']*'['"]*|[^'">])*>/

    opening_tags = file_content.scan(opening_regex)
    closing_tags = file_content.scan(closing_regex)

    opening_tags = sanitize_opening_tags(opening_tags)
    closing_tags = sanitize_closing_tags(closing_tags)

    opening_tags.sort == closing_tags.sort
  end
end
