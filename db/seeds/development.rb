# Ffaker : https://github.com/ffaker/ffaker/tree/master/lib/ffaker/data
# ----------------
# Common
# -----------------
today      =     Time.zone.now
created_at =     today
updated_at =     today

def n_out_of_m?(n, m)
  (1..m).to_a.sample <= n
end

# -----------------
# Users
# -----------------
User.create!(
  firstname:             'Etienne',
  lastname:              'WEIL',
  email:                 'weil.etienne@hotmail.fr',
  role:                   2,
  cell_phone_nr:          FFaker::PhoneNumberFR::mobile_phone_number,
  address:                '18, rue de Cotte Paris 12e',
  # uid:                    105205260860063499768
)
18.times do |n|
  uid =                   (105205260860063499768 + n + 1).to_s
  firstname =              FFaker::NameFR.unique.first_name
  lastname =               FFaker::NameFR::unique.last_name
  email =                  FFaker::Internet.free_email
  role =                   (0..3).to_a.sample
  is_registered =          n_out_of_m?(8, 11)
  cell_phone_nr =          nil
  address =                nil
  if is_registered
    cell_phone_nr =        FFaker::PhoneNumberFR::mobile_phone_number
    address =              FFaker::AddressFR::unique.full_address
    # setup: 0, invited: 1, googled: 2, registered: 3, archived: 4
    status =               3
  else
    status =              (0..3).to_a.sample
    status =              4 if status == 3
  end


  User.create!(
    email:                email,
    firstname:            firstname,
    lastname:             lastname,
    status:               status,
    cell_phone_nr:        cell_phone_nr,
    address:              address,
    role:                 role
  )
end
users = User.all

# Theaters
Theater.create!(
  theater_name:       'Kibelé',
  location:    '12, rue de l\'échiquier, 75010 PARIS',
  manager:              'Mr. Fraise',
  manager_phone:        '0148245774'
)
Theater.create!(
  theater_name:       'Centre Oudiné',
  location:    '16, rue Oudiné',
  manager:              'Mr. Battard',
  manager_phone:        '0521452142'
)
Theater.create!(
  theater_name:       "Le #{ FFaker::Animal.common_name } agité",
  location:              FFaker::AddressFR::unique.full_address,
  manager:              "Mr. #{ FFaker::NameFR::unique.last_name }",
  manager_phone:        FFaker::PhoneNumberFR::mobile_phone_number
)
theaters = Theater.all

# Events

16.times do |n|
  name  = "Le #{ FFaker::Name.name } étoilé "
  event_date = today + (-200..200).to_a.sample * 3600 * 24
  duration = Event::DURATIONS.sample[1]
  note = FFaker::Lorem::paragraph(1)
  Performance.create!(
    theater:             theaters.sample,
    title:                "Les Mentals moisis par les Sésames",
    user:                 users.sample,
    note:                 note,
    duration:             duration,
    event_date:           event_date,
    created_at:           created_at,
    updated_at:           updated_at,
    type:                 'Performance',

  )
end
performances = Performance.all

14.times do |n|
  event_date = today + (-200..200).to_a.sample * 3600 * 24
  name  = "Cours du #{ event_date }"
  duration = Event::DURATIONS.sample[1]
  note = FFaker::Lorem::paragraph(1)
  Course.create!(
    theater:             theaters.sample,
    title:               name,
    note:                 note,
    duration:             duration,
    event_date:           event_date,
    created_at:           created_at,
    updated_at:           updated_at,
    type:                 'Course',
    courseable_id:        users.sample.id,
    courseable_type:      'User'
  )
end
performances = Performance.all

# Actors
performances.each do |event|
  6.times do |n|
    Actor.create(
      event_id:       event.id,
      user_id:        User.active.sample.id,
      stage_role:     Actor::stage_roles.keys.sample.to_sym
    )
  end
end
# Coach
Coach.create!(
  firstname: 'Aline',
  lastname: 'PETIT',
  cell_phone_nr: '0623142151',
  email: "aline.petit@gmail.tu",
  note: "test is good"
)
# PollOpinions
2.times do |n|
  question = "#{ FFaker::Lorem::sentence(1)} ?"
  expiration_date = Date.today + (10..30).to_a.sample.days
  PollOpinion.create!(
    question:           question,
    expiration_date:    expiration_date,
    type:               'PollOpinion'
  )
end
poll_opinions = PollOpinion.all

# PollDates
2.times do |n|
  question = "Quand fait on le #{ FFaker::Lorem::sentence(1)} ?"
  expiration_date = Date.today + (10..30).to_a.sample.days
  PollDate.create!(
    question:           question,
    expiration_date:    expiration_date,
    type:               'PollDate'
  )
end
poll_dates = PollDate.all

#PollAnswers
poll_opinions.each do |poll|
  (2..4).to_a.sample.times do |n|
    answer_label = FFaker::Lorem::sentence(1)
    Answer.create!(
      answer_label: answer_label,
      poll_id: poll.id
    )
  end
end

poll_dates.each do |poll|
  (2..4).to_a.sample.times do |n|
    date_answer = Date.today + (10..30).to_a.sample.days
    Answer.create!(
      date_answer: date_answer,
      poll_id: poll.id
    )
  end
end
