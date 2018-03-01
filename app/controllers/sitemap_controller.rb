class SitemapController < ApplicationController
  unloadable
  caches_action :index
  
  def index
    ret = []
    Redmine::Search.available_search_types.dup.each do |scope|
      klass = scope.singularize.camelcase.constantize
      ranks_and_ids_in_scope = klass.search_result_ranks_and_ids([], User.current, nil, {})
      ret += ranks_and_ids_in_scope.map {|rs| [scope, rs]}
    end
    ret.map! {|scope, r| [scope, r.last]}
    
    results_by_scope = Hash.new {|h,k| h[k] = []}
    ret.group_by(&:first).each do |scope, scope_and_ids|
      klass = scope.singularize.camelcase.constantize
      results_by_scope[scope] += klass.search_results_from_ids(scope_and_ids.map(&:last))
    end

    @results = ret.map do |scope, id|
      results_by_scope[scope].detect {|record| record.id == id}
    end.compact
  end
end
