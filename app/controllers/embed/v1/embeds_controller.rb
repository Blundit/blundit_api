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
      if @type == 'claim'
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


  end
end
