#get 'issues/:id/view_stats', controller: :issue_reads, action: :view_stats, id: /\d+/
Rails.application.routes.draw do
  resources :issue_reads, only: [:destroy, :index]
  get 'issues/:id/view_stats', controller: :issue_reads, action: :view_stats, id: /\d+/
  delete '/issue_reads', to: 'issue_reads#destroy', as: :destroy_issue_read
end
