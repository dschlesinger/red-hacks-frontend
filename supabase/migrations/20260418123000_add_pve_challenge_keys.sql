CREATE TABLE IF NOT EXISTS public.pve_challenge_keys (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  game_id UUID NOT NULL REFERENCES public.games(id) ON DELETE CASCADE,
  challenge_id UUID NOT NULL REFERENCES public.challenges(id) ON DELETE CASCADE,
  target_secret_key TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (game_id, challenge_id)
);

CREATE INDEX IF NOT EXISTS idx_pve_challenge_keys_game_id
  ON public.pve_challenge_keys(game_id);

CREATE INDEX IF NOT EXISTS idx_pve_challenge_keys_challenge_id
  ON public.pve_challenge_keys(challenge_id);

ALTER TABLE public.pve_challenge_keys ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'pve_challenge_keys'
      AND policyname = 'Allow all operations for anon'
  ) THEN
    CREATE POLICY "Allow all operations for anon"
      ON public.pve_challenge_keys
      FOR ALL
      USING (true)
      WITH CHECK (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'pve_challenge_keys'
      AND policyname = 'Allow all operations for authenticated'
  ) THEN
    CREATE POLICY "Allow all operations for authenticated"
      ON public.pve_challenge_keys
      FOR ALL
      TO authenticated
      USING (true)
      WITH CHECK (true);
  END IF;
END $$;
