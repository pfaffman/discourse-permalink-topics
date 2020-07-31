# frozen_string_literal: true
require 'rails_helper'

describe TopicCreator do
  fab!(:user)      { Fabricate(:user, trust_level: TrustLevel[2]) }

  let(:valid_attrs) { Fabricate.attributes_for(:topic) }
    context 'permalinks' do

      before do
        SiteSetting.permalink_topics_enabled = true
      end

      it "will create a permalink for new topic in a permalink category" do
        category = Fabricate(:category)
        category.custom_fields['category_permalink'] = 'prefix'
        category.save
        topic = TopicCreator.create(user, Guardian.new(user), valid_attrs.merge(category: category.id))
        expect(topic).to be_valid
        expect(topic.category).to eq(category)
        permalink = Permalink.find_by(topic_id: topic.id)
        expect(permalink.topic_id).to eq(topic.id)
      end

      it "will not create a permalink for new topic in a category with no permalink" do
        category = Fabricate(:category)
        topic = TopicCreator.create(user, Guardian.new(user), valid_attrs.merge(category: category.id))
        expect(topic).to be_valid
        expect(topic.category).to eq(category)
        puts "ccf: #{category.custom_fields['category_permalink']}"
        permalink = Permalink.find_by(topic_id: topic.id)
        expect(permalink).to eq(nil)
      end

      it "will not create a permalink for new topic in a permalink category if site setting is off" do
        SiteSetting.permalink_topics_enabled = false
        category = Fabricate(:category)
        category.custom_fields['category_permalink'] = 'prefix'
        category.save
        topic = TopicCreator.create(user, Guardian.new(user), valid_attrs.merge(category: category.id))
        expect(topic).to be_valid
        expect(topic.category).to eq(category)
        permalink = Permalink.find_by(topic_id: topic.id)
        expect(permalink).to eq(nil)
      end
    end
end
