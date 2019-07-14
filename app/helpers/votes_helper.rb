# frozen_string_literal: true

module VotesHelper
  BADGE_CLASSES = %w[first second third fourth fifth other].freeze

  def vote_date_header(answer_vote)
    render partial: 'vote_dates/date_panel',
           locals: { display_date: answer_vote[:answer].date_answer }
  end

  def updown_icons
    raise 'updown_icons'
  end

  def others_votes_list(votes, user)
    vote_first_label = votes.any? ? votes.first.vote_label : '?'
    output =  case vote_first_label
              when '?'
                "<span class='text-muted'>#{user.firstname_extended}</span>"
              when 'yess'
                badge_user_from_id(user.id)
              when 'noway'
                "<strike>#{user.firstname_extended}</strike>"
              else # maybe
                "<span class='maybe-vote'>#{user.firstname_extended} ?</span>"
              end
    output.html_safe
  end

  def new_or_edit_opinion_path(vote)
    if vote.try(:answer_id).nil?
      edit_vote_opinion_path(vote)
    else
      # TODO: not tested at all
      new_poll_opinion_vote_opinion_path(vote)
    end
  end

  def badge_vote_result(rank, number)
    rank = [rank, BADGE_CLASSES.count - 1].min
    "<span class='badging #{BADGE_CLASSES[rank]}'>#{number}</span>"
  end

  def winner_line(answer_vote, winners)
    if winners.include? answer_vote[:answer].id
      image_tag('icons/png/009-medal.png', size: 25)
    else
      image_tag('transp.png')
    end
  end
end
