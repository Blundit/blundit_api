module Embed::V1
  class EmbedsController < ApplicationController
    after_filter :allow_iframe, only: [:show]
    def show
      if !params.has_key?(:key)
        render json: { message: "Key required"}
        return
      end

      embeds = Embed.where({embed_key: params[:key]})

      if embeds.count == 0
        render :no_item
        return
      end

      embed = embeds.first
      embed.embed_views << EmbedView.create(ip: request.ip)

      @object = embed.embed_items.first.object
      @type = embed.embed_items.first.type
      if @object.categories
        @category_icon = "<span class='#{get_category_icon(@object.categories[0].id)}'></span>"
      else
        @category_icon = "<span></span>"
      end
      @status_type = "unknown"
      if @object.status == 0 and @object.vote_value.nil?
        @status_type = "unknown"
      elsif @object.status == 0 and !@object.vote_value.nil?
        @status_type = "false"
      elsif @object.status == 1 and !@object.vote_value.nil? and @object.vote_value >= 0.5
        @status_type = "true"
      elsif @object.status == 1 and !@object.vote_value.nil? and @object.vote_value < 0.5
        @status_type = "false"
      end
      @status_class = "claim-card__status--" + @status_type

      @statuses = { 
        "unknown": "unknown",
        "in-progress": "voting in progress",
        "true": "true",
        "false": "false"
      }

      @status_text = @statuses[@status_type.to_sym]
      

      if @type == 'claim'
        # TODO: Make this pull the real numbers
        @experts_agree = (rand()*100).floor
        @experts_disagree = (rand()*100).floor
        @evidence_for = (rand()*100).floor
        @evidence_against = (rand()*100).floor
        @vote_status = vote_status(@object)
        @time_to_vote = time_to_vote(@object)
        @votes_yes = (rand()*100).floor
        @votes_no = (rand()*100).floor
        @votes_unsure = (rand()*100).floor
        @bookmarks_count = (rand()*100).floor
        render :claim
        return
      elsif @type == 'prediction'
        render :prediction
        return
      elsif @type == 'expert'
        render :expert
        return
      end
    end


    def no_item

    end


    def vote_status(object)
      # TODO: Make this bastard work.
      @voteable = Time.parse((Time.now + 1.day).to_s)
      @now = Time.now
  
      if (@object.status != 0) 
        return "closed"
      end
      if (@voteable < @now) 
        return "open"
      end
      if (@voteable >= @now)
        return "pending"
      end
    end


    def time_to_vote(object)
      # TODO: Make this work properly
      t = Time.now
      t = t + ((rand()*14).floor).days

      return t
    end


    def get_category_icon(id)
      icon = "fas fa-question"

      ids = {
        "category_testing": "fa-home",
        "category_1": "fas fa-flask",
        "category_2": "fas fa-flask",
        "category_3": "fas fa-flask",
        "category_4": "fas fa-flask",
        "category_5": "fas fa-eye",
        "category_6": "fas fa-flask",
        "category_7": "fas fa-flask",
        "category_8": "fas fa-flask",
        "category_9": "fas fa-flask",
        "category_10": "fas fa-flask",
        "category_11": "fas fa-flask",
        "category_12": "fas fa-flask",
        "category_13": "fas fa-flask",
        "category_14": "fas fa-flask",
        "category_15": "fas fa-eye",
        "category_16": "fas fa-flask",
        "category_17": "fas fa-flask",
        "category_18": "fas fa-flask",
        "category_19": "fas fa-flask",
        "category_20": "fas fa-flask",
        "category_21": "fas fa-flask",
        "category_22": "fas fa-flask",
        "category_23": "fas fa-flask",
        "category_24": "fas fa-flask",
        "category_25": "fas fa-eye",
        "category_26": "fas fa-flask",
        "category_27": "fas fa-flask",
        "category_28": "fas fa-flask",
        "category_29": "fas fa-flask",
        "category_30": "fas fa-flask",
        "category_31": "fas fa-flask",
        "category_32": "fas fa-flask",
        "category_33": "fas fa-flask",
        "category_34": "fa-balance-scale",
        "category_35": "fas fa-eye",
        "category_36": "fas fa-flask",
        "category_37": "fas fa-flask",
        "category_38": "fas fa-flask",
        "category_39": "fas fa-flask",
        "category_40": "fas fa-flask",
        "category_41": "fas fa-flask",
        "category_42": "fas fa-flask",
        "category_43": "fas fa-flask",
        "category_44": "fas fa-flask",
        "category_45": "fas fa-eye",
        "category_46": "fas fa-flask",
        "category_47": "fas fa-flask",
        "category_48": "fas fa-flask",
        "category_49": "fas fa-flask",
        "category_50": "fas fa-flask",
        "category_51": "fas fa-flask",
        "category_52": "fas fa-flask",
        "category_53": "fas fa-flask",
        "category_54": "fas fa-flask",
      }
      if (ids[("category_"+id.to_s).to_sym]) 
        icon = ids[("category_"+id.to_s).to_sym]
      end

      return icon
    end


  end
end
