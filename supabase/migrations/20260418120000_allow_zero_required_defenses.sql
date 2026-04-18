-- Allow rounds with a single challenge by permitting required_defenses = 0.
-- Older schema versions enforced required_defenses > 0, which blocks 1-challenge rounds.

ALTER TABLE public.rounds
  DROP CONSTRAINT IF EXISTS rounds_required_defenses_check;

ALTER TABLE public.rounds
  ALTER COLUMN required_defenses SET DEFAULT 0;
