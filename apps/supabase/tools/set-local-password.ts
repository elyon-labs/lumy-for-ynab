import { createClient } from '@supabase/supabase-js'

// All fields from `supabase status`
const url = 'http://127.0.0.1:54321'
const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
const userId = Deno.env.get('SUPABASE_USER_ID')
const newPassword = Deno.env.get('SUPABASE_USER_PASSWORD')

if (!serviceKey || !userId || !newPassword) {
  throw new Error(
    'SUPABASE_SERVICE_ROLE_KEY, SUPABASE_USER_ID, and SUPABASE_USER_PASSWORD must be set',
  )
}

const supabase = createClient(url, serviceKey)

async function run() {
  const { data, error } = await supabase.auth.admin.updateUserById(userId, {
    password: newPassword,
  })
  if (error) throw error
  console.log('Updated user:', data.user?.id, data.user?.email)
}

run().catch(console.error)
