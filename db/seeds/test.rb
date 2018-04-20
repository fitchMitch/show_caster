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
  password:              '123456',
  password_confirmation: '123456',
  role:                   2,
  cell_phone_nr:          '06 23 04 30 52',
  address:                '18, rue de Cotte Paris 12e'
)
