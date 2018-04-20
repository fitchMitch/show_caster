# Ffaker : https://github.com/ffaker/ffaker/tree/master/lib/ffaker/data
# ----------------
# Common
# -----------------
today      =     Time.zone.now
created_at =     today
updated_at =     today
def n_out_of_m?(n,m)
  (1..m).to_a.sample <= n
end
# -----------------
# Users
# -----------------
# invitation_created_at = today - ((34..64).to_a.sample * 3600 * 24)
# invitation_accepted_at = invitation_created_at + ((1..48).to_a.sample * 3600)
User.create!(
  firstname:             'Etienne',
  lastname:              'WEIL',
  email:                 'weil.etienne@hotmail.fr',
  role:                   2,
  cell_phone_nr:          '06 23 04 30 52',
  address:                '18, rue de Cotte Paris 12e'
)
11.times do |n|
  firstname =              FFaker::NameFR.unique.first_name
  lastname =               FFaker::NameFR::unique.last_name
  email =                  FFaker::Internet.free_email
  role =                   (0..3).to_a.sample
  status =                0
  # invitation_created_at =  today - (3..30).to_a.sample * 3600 * 24
  # invitation_accepted_at =  n_out_of_m?(3,5) ? invitation_created_at + (1..48).to_a.sample * 3600 : nil
  # cell_phone_nr =          FFaker::PhoneNumberFR::mobile_phone_number
  # unless invitation_accepted_at.nil?
  # address =              FFaker::AddressFR::unique.full_address
  # end

  User.create!(
    email:                email,
    firstname:            firstname,
    lastname:             lastname,
    status:               status,
    # cell_phone_nr:        cell_phone_nr,
    # address:              address,
    # invitation_created_at: invitation_created_at,
    # invitation_accepted_at: invitation_accepted_at,
    role:                 role
  )
end
users = User.all
#
# # Locations
# Location.create!(
#   location_name:       'Kibelé',
#   location_address:    '12, rue de l\'échiquier, 75010 PARIS',
#   tenant:              'Mr. Fraise',
#   tenant_phone:        '0148245774',
#   created_at:           created_at,
#   updated_at:           updated_at
# )
# Location.create!(
#   location_name:       'Centre Oudiné',
#   location_address:    '16, rue Oudiné',
#   tenant:              'Mr. Battard',
#   tenant_phone:        '0121252142',
#   created_at:           created_at,
#   updated_at:           updated_at
# )
# locations = Location.all
#
# # Events
#
# 25.times do |n|
#   name  = "Le #{FFaker::Name.name}"
#   event_date = today + (-200..200).to_a.sample * 3600 * 24
#   duration = Event::DURATIONS.sample[1]
#   note = FFaker::Lorem::paragraph(1)
#   Event.create!(
#     location:             locations.sample,
#     user:                 users.sample,
#     note:                 note,
#     duration:             duration,
#     event_date:           event_date,
#     created_at:           created_at,
#     updated_at:           updated_at
#   )
# end
# events = Event.all
#
# # Actors
#
# events.each do |event|
#   6.times do |n|
#     Actor.create(
#       event_id:       event.id,
#       user_id:        users.sample.id    ,
#       stage_role:     Actor::stage_roles.keys.sample.to_sym
#     )
#   end
# end
