module ApplicationHelper

  def f_date(date)
    if "#{date.year}#{date.month}#{date.day}" == "#{Time.now.year}#{Time.now.month}#{Time.now.day}"
      r_date = "Hoy"
      r_date = r_date + " a las " + date.strftime("%l:%M %P") if (date.hour != nil)
    elsif "#{date.year}#{date.month}#{date.day}" == "#{Time.now.year}#{Time.now.month}#{Time.now.day - 1}"
      r_date = "Ayer"
      r_date = r_date + " a las " + date.strftime("%l:%M %P") if (date.hour != nil)
    elsif "#{date.year}#{date.month}#{date.day}" == "#{Time.now.year}#{Time.now.month}#{Time.now.day + 1}"
      r_date = "Mañana"
      r_date = r_date + " a las " + date.strftime("%l:%M %P") if (date.hour != nil)
    else
      r_date = I18n.l(date, format: '%d de %B %Y a las %l:%M %P').capitalize
      # d = "#{date.year}#{date.month}#{date.day}".to_i
      # t = "#{Time.now.year}#{Time.now.month}#{Time.now.day}".to_i
      # if d > t
      #   r_date = "En #{t - d} días"
      # else
      #   r_date = "Hace #{d - t} días"
      # end
    end
  end

  def f_date_no_time(date)
    if "#{date.year}#{date.month}#{date.day}" == "#{Time.now.year}#{Time.now.month}#{Time.now.day}"
      r_date = "Hoy a las " + date.strftime("%l:%M %P")
    elsif "#{date.year}#{date.month}#{date.day}" == "#{Time.now.year}#{Time.now.month}#{Time.now.day - 1}"
      r_date = "Ayer"
    elsif "#{date.year}#{date.month}#{date.day}" == "#{Time.now.year}#{Time.now.month}#{Time.now.day + 1}"
      r_date = "Mañana a las " + date.strftime("%l:%M %P")
    else
      d = date.to_date
      t = Time.now.to_date
      if d > t
        r_date = "En #{(d - t).to_i} días"
      else
        r_date = "Hace #{(t - d).to_d} días"
      end
    end
  end

end
