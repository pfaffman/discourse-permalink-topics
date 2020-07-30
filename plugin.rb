# frozen_string_literal: true

# name: PermalinkTopics
# about:
# version: 0.1
# authors: pfaffman
# url: https://github.com/pfaffman

register_asset "stylesheets/common/permalink-topics.scss"

enabled_site_setting :permalink_topics_enabled

PLUGIN_NAME ||= "PermalinkTopics".freeze

after_initialize do
  # see lib/plugin/instance.rb for the methods available in this context

  module ::PermalinkTopics
    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace PermalinkTopics
    end
  end

  require_dependency "application_controller"
  class ::ApplicationController
  end
  require 'categories_controller'
  require 'topics_controller'

  class ::TopicsController
    before_action :create_topic_permalink, only: [:create, :update]

    # converts the Ember array into the string that Rails needs
    def create_topic_permalink
      return unless :permalink_topics_enabled
      if has_category_permalink?
        puts "getting prefix"
        permalink_prefix = Category.find(params[:category_id]).custom_fields['category_permalink']
        puts "Pre: #{permalink_prefix}"
        url = "#{permalink_prefix}/#{params[:topic_id]}"
        puts "MAKING THIS: #{url} --"
        Permalink.find_or_create_by(url: url, topic_id: params[:topic_id])
      end
    end

    def has_category_permalink?
      puts "XXXXXXXXXXXXX looking for permalink"
      puts "Cat: #{params[:category_id]}"
      c = Category.find(params[:category_id])
      permalink = c.custom_fields['category_permalink']
      puts "GOT A PERMALINK@!!! #{permalink}" if permalink
      :permalink_topics_enabled && permalink
    end

  end

  class PermalinkTopics::ActionsController < ::ApplicationController
    requires_plugin PLUGIN_NAME

    before_action :ensure_logged_in

    def list
      render json: success_json
    end
  end

  class ::Topic
    def create_topic_permalink
      puts "Creating the permalinks"
      if has_category_permalink?
        permalink_prefix = self.category.custom_fields['category_permalink']
        puts "P: #{permalink_prefix}"
        url = "#{permalink_prefix}/#{self.id}"
        puts "MAKING THIS in the model: #{url} --"
        Permalink.find_or_create_by(url: url, topic_id: self.id)
      end
    end
    def has_category_permalink?
      permalink = SiteSetting.permalink_topics_enabled && self.category.custom_fields['category_permalink']
      :permalink_topics_enabled && permalink
    end
  
    after_update do
      create_topic_permalink
    end
    after_create do
      create_topic_permalink
    end
  end
  PermalinkTopics::Engine.routes.draw do
    get "/list" => "actions#list"
  end

  Discourse::Application.routes.append do
    mount ::PermalinkTopics::Engine, at: "/permalink-topics"
  end

  Site.preloaded_category_custom_fields << 'category_permalink' if Site.respond_to? :preloaded_category_custom_fields
  add_to_serializer(:basic_category, :category_permalink) { object.custom_fields["category_permalink"] }

end
