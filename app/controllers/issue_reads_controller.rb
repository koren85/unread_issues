class IssueReadsController < ApplicationController
  def view_stats
    @issue = Issue.find(params[:id])
    if Redmine::Plugin.installed?(:redmine_issue_tabs) &&
       (
        User.current.admin? || (Redmine::Plugin.installed?(:global_roles) && User.current.global_permission_to?(:view_issue_view_stats)) ||
        (!Redmine::Plugin.installed?(:global_roles) && User.current.allowed_to?(:view_issue_view_stats, @issue.project))
       )
      @issue_reads = @issue.uis_issue_reads
    else
      render_403
    end
  end

  def index
    @issue_reads = IssueRead.where(user_id: User.current.id).order(:read_date)

    if params[:last_week].present?
      @issue_reads = @issue_reads.where(read_date: 1.week.ago.beginning_of_week..1.week.ago.end_of_week)
    elsif params[:current_month].present?
      @issue_reads = @issue_reads.where(read_date: Date.today.beginning_of_month..Date.today.end_of_month)
    else
      @issue_reads = @issue_reads.where(read_date: Date.today.beginning_of_week..Date.today.end_of_week)
    end
  end

  def destroy
    if request.xhr?
      issue_id = params[:issue_id]
      user_id = params[:user_id]
      issue_read = IssueRead.find_by(issue_id: issue_id, user_id: user_id)

      if issue_read
        issue_read.destroy
        render json: { success: true }
      else
        render json: { success: false, error: 'Запись не найдена' }
      end
    else
      issue_read = IssueRead.find(params[:id])

      if issue_read && issue_read.user_id == User.current.id
        issue_read.destroy
        flash[:notice] = 'Запись успешно удалена'
      else
        flash[:error] = l(:error_issue_read_not_found)
      end

      redirect_to issue_reads_path
    end
  end

  private

  def group_issue_reads(issue_reads)
    grouped = {
      'Текущая неделя' => [],
      'Прошлая неделя' => [],
      'Этот месяц' => []
    }

    today = Date.today
    issue_reads.each do |issue_read|
      read_date = issue_read.read_date.to_date

      if read_date >= today.beginning_of_week
        grouped['Текущая неделя'] << issue_read
      elsif read_date >= (today - 1.week).beginning_of_week
        grouped['Прошлая неделя'] << issue_read
      elsif read_date >= today.beginning_of_month
        grouped['Этот месяц'] << issue_read
      end
    end

    grouped
  end
end
