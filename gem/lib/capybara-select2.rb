require "capybara-select2/version"
require 'rspec/core'

module Capybara
  module Select2
    def select2(value, options = {})
      raise "Must pass a hash containing 'from' or 'xpath'" unless options.is_a?(Hash) and [:from, :xpath].any? { |k| options.has_key? k }

      if options.has_key? :xpath
        select2_container = first(:xpath, options[:xpath])
      else
        select_name = options[:from]
        select2_container = first("label", text: select_name).find(:xpath, '..').find(".select2-container")
      end

      select2_container.find(".select2-choice").click

      if options.has_key? :search
        find(:xpath, "//body").find("input.select2-input").set(value)
        page.execute_script(%|$("input.select2-input:visible").keyup();|)
        drop_container = ".select2-results"
      else
        drop_container = ".select2-drop"
      end

      [value].flatten.each do |value|
        select2_container.find(:xpath, "a[contains(concat(' ',normalize-space(@class),' '),' select2-choice ')] | ul[contains(concat(' ',normalize-space(@class),' '),' select2-choices ')]").click
        find(:xpath, "//body").find("#{drop_container} li", text: value).click
      end
    end
    
    def select2_ajax(value, options = {})
      raise "Must pass a hash containing 'from' or 'xpath'" unless options.is_a?(Hash) and [:from, :xpath].any? { |k| options.has_key? k }

      if options.has_key? :xpath
        select2_container = first(:xpath, options[:xpath])
      else
        select_name = options[:from]
        select2_container = first("label", text: select_name).find(:xpath, '..').find(".select2-container")
      end

      select2_container.find(".select2-choice").click

      drop_container = '.select2-drop'
      if options.has_key? :search
        if options.has_key? :parent
          find(:xpath, "//body").find("#{options[:parent]} input.select2-input").set(value)
          page.execute_script(%|$("#{options[:parent]} input.select2-input:visible").keyup();|)
        else
          find(:xpath, "//body").find("input.select2-input").set(value)
          page.execute_script(%|$("input.select2-input:visible").keyup();|)
        end
      end

      [value].flatten.each do |value|
        find(:xpath, "//body").find("#{drop_container} li", text: value).click
      end
    end

    def select2_multiple(value, options = {})
      raise "Must pass a hash containing 'from'" if not options.is_a?(Hash) or not options.has_key?(:from)
      select_name = options[:from]

      select2_container=first("label", text: select_name).find(:xpath, '..').find(".select2-container")

      [value].flatten.each do |value|
        select2_container.find(:xpath, "a[contains(concat(' ',normalize-space(@class),' '),' select2-choice ')] | ul[contains(concat(' ',normalize-space(@class),' '),' select2-choices ')]").click
        find(:xpath, "//body").find(".select2-drop li", text: value).click
      end
    end
  end
end

RSpec.configure do |c|
  c.include Capybara::Select2
end
