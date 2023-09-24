module UnreadIssues
  module Hooks
    class ViewIssuesFormDetailsBottomHook < Redmine::Hook::ViewListener
      render_on :view_issues_form_details_bottom, partial: 'unread_issues/add_custom_button'
    end
  end
end
