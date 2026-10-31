import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

/**
 * Deletes the caller's account.
 *
 * This is the one thing a client cannot do for itself. There is no delete
 * policy on `public.users`, and removing the row in `auth.users` needs the
 * service role — so it is here, and it is the only function in this project
 * that holds that key.
 *
 * Which account is deleted comes from the caller's own JWT and never from the
 * request body. The other functions here take a `user_id` from the body, which
 * is safe for them because they act through an anon-key client and row-level
 * security re-checks ownership. Nothing re-checks the service role, so a body
 * parameter here would be a way to delete somebody else's account. There are
 * no parameters at all.
 *
 * `public.users` goes first. Everything the person configured — category
 * views, spend trackers, frugal months, templates, devices — cascades from
 * that row, and `public.users.id` is not a foreign key to `auth.users`, so
 * deleting the auth row first would leave all of it behind with no account it
 * belongs to and no way to reach it again. In this order a failure part way
 * leaves an account whose configuration has gone, which the caller is told
 * about and can retry: both steps are idempotent.
 */

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

function json(body: unknown, status: number): Response {
  return new Response(JSON.stringify(body), {
    headers: { ...corsHeaders, "Content-Type": "application/json" },
    status,
  });
}

function bearerToken(req: Request): string | null {
  const header = req.headers.get("Authorization");
  if (!header) return null;

  const [scheme, token] = header.split(" ");

  return scheme === "Bearer" && token ? token : null;
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const token = bearerToken(req);
    if (token === null) {
      return json({ error: "Missing bearer token" }, 401);
    }

    const admin = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
      { auth: { autoRefreshToken: false, persistSession: false } },
    );

    // The account to delete, established from the token rather than claimed.
    const { data: caller, error: callerError } = await admin.auth.getUser(
      token,
    );
    if (callerError || !caller.user) {
      return json({ error: "Invalid token" }, 401);
    }

    const userId = caller.user.id;

    // Cascades to every table the person configured. A caller who never
    // linked a YNAB account has no row here, which is not an error: the
    // account still has to go.
    const { error: configError } = await admin
      .from("users")
      .delete()
      .eq("id", userId);

    if (configError) {
      console.error("Failed to delete user configuration:", configError);
      return json({ error: configError.message }, 400);
    }

    const { error: authError } = await admin.auth.admin.deleteUser(userId);
    if (authError) {
      console.error("Failed to delete auth user:", authError);
      return json({ error: authError.message }, 400);
    }

    return json({ deleted: true }, 200);
  } catch (error) {
    console.error("Unexpected error:", error);
    return json({ error: "Internal server error" }, 500);
  }
});
