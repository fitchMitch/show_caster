module Commontator
  module ApplicationHelper
    def javascript_proc
      Commontator.javascript_proc.call(self).html_safe
    end

    def comment_creation_time(comment)
      I18n.t(
        "commontator.comment.status.posted",
        posted_at: time_ago_in_words(comment.created_at)
      )
    end

    def comment_update_time(comment)
      I18n.t(
        "commontator.comment.status.updated",
        updated_at: time_ago_in_words(comment.updated_at)
      )
    end
  end
end
