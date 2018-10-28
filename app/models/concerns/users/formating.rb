module Users
  module Formating
    extend ActiveSupport::Concern

    def pick(a, b)
      (a..b).to_a.sample.to_i
    end

    def pick_color
      # background
      s_bckg = pick(66, 100)
      l_bckg = pick(32, 50)
      # txt
      s_txt  = pick(36, 76)
      l_txt  = pick(76, 95)
      # hue
      h_user = h_random pick(0, 1000)

      letters = to_hsl(h_user, s_txt, l_txt)
      background = to_hsl(h_user, s_bckg, l_bckg)
      "#{letters};#{background}"
    end

    def first_and_last_name
      lastname_upper = lastname.upcase
      if firstname.nil?
        lastname_upper
      else
        firstname_cap = firstname.capitalize
        "#{firstname_cap} #{lastname_upper}"
      end
    end

    def first_and_l
      if firstname.nil? || firstname == ''
        lastname.upcase
      else
        "#{firstname} #{lastname[0].upcase}"
      end
    end

    def format_fields
      self.lastname = lastname.upcase if lastname.present?
      self.firstname = firstname.capitalize if firstname.present?
      self.email = email.downcase if email.present?
      phone_number_format
    end

    protected

    def phone_number_format
      phone_exists = cell_phone_nr.present?
      self.cell_phone_nr = format_by_two(cell_phone_nr) if phone_exists
    end

    private

    def format_by_two(nbr)
      nbr = nbr.sub('+33', '0').tr '^0-9', ''

      reg2 = /(\d{2})(\d{2})(\d{2})(\d{2})(\d+)/
      my_match = reg2.match(nbr)
      return nbr if my_match.nil? || nbr.length < 10
      my_match.captures.compact.join(' ')
    end

    def to_hex_color(nbr)
      incomplete_nr = nbr.to_s(16)
      '0' * (6 - incomplete_nr.length) + incomplete_nr
    end

    def h_random(index)
      gold = (1 + Math.sqrt(5)) / 2
      perso = gold * index.to_i
      nbr = (perso - perso.floor)
      ((nbr * 90) + 340).modulo(360).floor
    end

    def to_hsl(h, s, l)
      "hsl(#{h}, #{s}%, #{l}%)"
    end
  end
end
