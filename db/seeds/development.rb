# Ffaker : https://github.com/ffaker/ffaker/tree/master/lib/ffaker/data
# ----------------
# Common
# -----------------
today      =     Time.zone.now
created_at =     today
updated_at =     today

def randy(n)
  (0...n).to_a.sample
end

def n_out_of_m?(n, m)
  randy(m) <= n
end

def random_player
  User.all.to_a.sample
end

# -----------------
# Committees
# -----------------
committees = [
  'spectacle',
  'communication',
  'cours',
  'administratif',
  'financier',
  'vie de la troupe'
]

# -----------------
# Users
# -----------------

User.create!(
  firstname:             'Etienne',
  lastname:              'WEIL',
  email:                 'weil.etienne@hotmail.fr',
  password:              '123456',
  role:                   2,
  cell_phone_nr:          FFaker::PhoneNumberFR.mobile_phone_number,
  address:                '29, rue St Jean, Paris 75014'
)
16.times do |n|
  uid =             (105205260860063499768 + n + 1).to_s
  firstname =        FFaker::NameFR.first_name
  lastname =         FFaker::NameFR.unique.last_name
  email =            FFaker::Internet.free_email
  password =         '123456'
  role =             randy(4)
  is_registered =    n_out_of_m?(8, 11)
  cell_phone_nr =    nil
  address =          nil
  # committee =        committees.sample
  if is_registered
    cell_phone_nr =  FFaker::PhoneNumberFR.mobile_phone_number
    address =        FFaker::AddressFR.unique.full_address
    # invited: 0, missing_phone_nr: 1, registered_with_no_pic: 2 registered: 3, archived: 4
    status =         3
  else
    status =        randy(5)
    status =        4 if status == 3
  end

  User.create!(
    email: email,
    password: password,
    firstname: firstname,
    lastname: lastname,
    status: status,
    cell_phone_nr: cell_phone_nr,
    address: address,
    role: role
  )
end
users = User.all
# adding committees to the Users
# -----------------
users.each do |user|
  user.committee_list.add(committees.sample) if n_out_of_m?(4, 5)
  user.committee_list.add(committees.sample) if n_out_of_m?(1, 5)
  user.save
end
# -----------------
#Coaches
# -----------------
Coach.create!(
  firstname: 'Aline',
  lastname: 'PETIT',
  cell_phone_nr: '0623142151',
  email: 'aline.petit@gmail.tu',
  note: 'test is good'
)

4.times do |n|
  firstname     = FFaker::NameFR.unique.first_name
  lastname      = FFaker::NameFR.unique.last_name
  email         = FFaker::Internet.free_email
  cell_phone_nr = FFaker::PhoneNumberFR.mobile_phone_number

  Coach.create!(
    email: email,
    firstname: firstname,
    lastname: lastname,
    cell_phone_nr: cell_phone_nr
  )
end
coaches = Coach.all

# -----------------
# Theaters
# -----------------
Theater.create!(
  theater_name: 'Kibelé',
  location: '12, rue de l\'échiquier, 75010 PARIS',
  manager: 'Mr. Fraise',
  manager_phone: '0148245774'
)
Theater.create!(
  theater_name: 'Centre Oudiné',
  location: '16, rue Oudiné',
  manager: 'Mr. Battard',
  manager_phone: '0521452142'
)
Theater.create!(
  theater_name: "Le #{FFaker::AnimalUS.common_name} agité",
  location: FFaker::AddressFR.unique.full_address,
  manager: "Mr. #{FFaker::NameFR.unique.last_name}",
  manager_phone: FFaker::PhoneNumberFR.mobile_phone_number
)
theaters = Theater.all

# -----------------
# Events
# -----------------
16.times do |n|
  name = "Le #{FFaker::Name.name} étoilé "
  event_date = today + (-200..200).to_a.sample * 3600 * 24
  duration = Event::DURATIONS.sample[1]
  note = FFaker::Lorem.paragraph(1)
  private_event = n_out_of_m?(1, 5) ? false : true
  Performance.create!(
    theater: theaters.sample,
    title: "Les Mentals moisis par #{I18n.t('company_name_long')}",
    user: users.sample,
    private_event: private_event,
    note: note,
    duration: duration,
    event_date: event_date,
    created_at: created_at,
    updated_at: updated_at,
    type: 'Performance'
  )
end
performances = Performance.all

14.times do |n|
  event_date = today + (-200..200).to_a.sample * 3600 * 24
  name       = "Cours du #{event_date}"
  duration   = Event::DURATIONS.sample[1]
  note       = FFaker::Lorem.paragraph(1)
  if n_out_of_m?(4, 5)
    courseable_type = 'User'
    courseable_id = users.sample.id
  else
    courseable_type = 'Coach'
    courseable_id = coaches.sample.id
  end
  Course.create!(
    theater: theaters.sample,
    title: name,
    note: note,
    duration: duration,
    event_date: event_date,
    created_at: created_at,
    updated_at: updated_at,
    type: 'Course',
    courseable_id: courseable_id,
    courseable_type: courseable_type
  )
end
performances = Performance.all

# -----------------
# Actors
# -----------------
performances.each do |event|
  6.times do |n|
    Actor.create(
      event_id: event.id,
      user_id: User.active.sample.id,
      stage_role: Actor.stage_roles.keys.sample.to_sym
    )
  end
end
# PollSecretBallot
question        = "Acceptons nous #{FFaker::NameFR.first_name} dans la troupe ?"
expiration_date = Date.today + (randy(20) + 10).days
secret_ballot   = PollSecretBallot.create!(
  question: question,
  expiration_date: expiration_date,
  type: 'PollSecretBallot',
  owner: random_player
)
secret_ballots = [secret_ballot]

# PollOpinions
2.times do |n|
  question = "#{FFaker::Lorem.sentence(1)} ?"
  expiration_date = Date.today + (randy(20) + 10).days
  PollOpinion.create!(
    question: question,
    expiration_date: expiration_date,
    type: 'PollOpinion',
    owner: random_player
  )
end
poll_opinions = Poll.opinion_polls

# -----------------
# PollDates
# -----------------
2.times do |n|
  question = "Quand fait on le #{FFaker::Lorem.sentence(1)} ?"
  expiration_date = Date.today + (randy(20) + 10).days
  PollDate.create!(
    question: question,
    expiration_date: expiration_date,
    type: 'PollDate',
    owner: random_player
  )
end
poll_dates = Poll.date_polls

# PollAnswers
(poll_opinions + secret_ballots).each do |poll|
  (randy(2) + 2).times do
    answer_label = FFaker::Lorem.sentence(1)
    Answer.create!(
      answer_label: answer_label,
      poll_id: poll.id
    )
  end
end

poll_dates.each do |poll|
  (randy(2) + 2).times do
    date_answer = Date.today + (randy(20) + 10).days
    Answer.create!(
      date_answer: date_answer,
      poll_id: poll.id
    )
  end
end
# -----------------
# Votes
# -----------------
#for opinions
(poll_opinions + secret_ballots).each do |poll|
  poll.answers.each do |answer|
    users.sample(1 + randy(4)).each do |user|
      VoteOpinion.create!(
        user_id: user.id,
        poll_id: poll.id,
        answer_id: answer.id,
        vote_label: 'yess'
      )
    end
  end
end
#and for dates
date_options = Vote.vote_labels.keys
(poll_dates).each do |poll|
  poll.answers.each do |answer|
    users.sample(1 + randy(2)).each do |user|
      VoteDate.create!(
        user_id: user.id,
        poll_id: poll.id,
        answer_id: answer.id,
        vote_label: date_options.sample
      )
    end
  end
end

# -----------------
# Threads and comments
# -----------------
poll_opinions.each do |poll|
  Commontator::Thread.create!(
    # PollOpinion, ça passe ! Mais les sondages créés dans l'UI sont "Poll"
    commontable_type: poll.type,
    commontable_id: poll.id
  )
end
# Comments
Commontator::Thread.where(commontable_type: 'Poll').each do |thread|
  randy(4).times do
    Commontator::Comment.create!(
      thread_id: thread.id,
      body: FFaker::Lorem.sentence(randy(3) + 1),
      creator: users.sample
    )
  end
end
# -----------------
# Exercices
# -----------------
50.times do |n|
  title =        FFaker::Lorem.sentence(1).truncate(40)
  instructions = FFaker::Lorem.paragraph(2 + randy(3))
  category =     Exercice.categories.keys.sample
  skills =       %w(body_language emotion being_true long_tag_expression).sample(randy(3))
  focus =        FFaker::Lorem.paragraph(1)
  promess =      FFaker::Lorem.paragraph(1)
  energy_level = Exercice.energy_levels.keys.sample
  max_people =   Exercice.max_people.keys.sample

  Exercice.create!(
    title: title,
    instructions: instructions,
    category: category,
    focus: focus,
    promess: promess,
    energy_level: energy_level,
    max_people: max_people
  )
  Exercice.last.tap do |exercice|
    exercice.skill_list.add(skills.join(', '), parse: true)
  end.save
end
# -----------------
# Announces
# -----------------
3.times do |n|
  author_id =    users.sample.id
  title =        (FFaker::Lorem.sentence(1)).truncate(25)
  body =         (FFaker::Lorem.paragraph(2 + randy(3)).truncate(249))
  time_start =   Time.zone.now + 2.weeks - (0..28).to_a.sample.days
  time_end =     time_start + (1..3).to_a.sample.days

  Announce.create!(
    author_id: author_id,
    title: title,
    body: body,
    time_start: time_start,
    time_end: time_end
  )
end
