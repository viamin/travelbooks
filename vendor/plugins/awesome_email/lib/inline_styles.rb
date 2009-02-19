require 'hpricot'
require 'csspool'

CSS::SAC::GeneratedParser.send :include, CSS::SAC::Conditions

module ActionMailer
  module InlineStyles
    module ClassMethods
      # none
    end
    
    module InstanceMethods
      
      def inline(html)
        timing "Calling inline"
        css_doc = parse_css_doc(build_css_file_name_from_css_setting)
        html_doc = parse_html_doc(html)
        render_inline(css_doc, html_doc)
      end
      
      def render_message_with_inline_styles(method_name, body)
        timing "Calling render_message_with_inline_styles with method_name=#{method_name} and @css=#{@css}"
        message = render_message_without_inline_styles(method_name, body)
        return message if @css.blank?
        inline(message)
      end
      
      protected
      
      def render_inline(css_doc, html_doc)
        timing "Calling render_inline(css_doc=#{css_doc.pretty_inspect}, html_doc=#{html_doc})"
        css_doc.find_all_rules_matching(html_doc).each do |rule|
          inline_css = css_for_rule(rule)
          (html_doc/rule.selector.to_css).each{|e| e['style'] = inline_css + (e['style']||'') }
        end
        html_doc.to_s
      end
      
      def css_for_rule(rule)
        timing "Calling css_for_rule(#{rule})"
        rule.properties.map do |key, value, important|
          build_css(key, value, important)
        end.join
      end
      
      def build_css(key, value, important)
        timing "Calling build_css(key=#{key}, value=#{value}, important=#{important})"
        delimiter = (key == 'font-family') ? ', ' : ' '
        values = [value].flatten.join(delimiter)
        "#{key}:#{values}#{important ? ' !important' : ''};"
      end
      
      def parse_html_doc(html)
        timing "Calling parse_html_doc"
        Hpricot.parse(html)
      end
      
      def parse_css_doc(file_name)
        timing "Calling parse_css_doc on #{file_name}"
        sac = CSS::SAC::Parser.new
        sac.parse(parse_css_from_file(file_name))
      end
      
      def parse_css_from_file(file_name)
        timing "Calling parse_css_from_file on #{file_name}"
        files = Dir.glob(File.join(RAILS_ROOT, '**', file_name))
        files.blank? ? '' : File.read(files[0])
      end
      
      def build_css_file_name_from_css_setting
        timing "Calling build_css_file_name_from_css_setting (@css = #{@css})"
        @css.blank? ? '' : build_css_file_name(@css)
      end
      
      def build_css_file_name(css_name)
        timing "Calling build_css_file_name with #{css_name}"
        file_name = "#{css_name}.css" unless css_name.end_with?('.css')
        Dir.glob(File.join(RAILS_ROOT, '**', file_name))[0] || File.join(RAILS_ROOT, 'public', 'stylesheets', 'mails', file_name)
      end
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
      
      receiver.class_eval do
        adv_attr_accessor :css
        alias_method_chain :render_message, :inline_styles
      end
    end
  end
end

ActionMailer::Base.send :include, ActionMailer::InlineStyles