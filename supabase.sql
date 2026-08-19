create table if not exists public.profiles_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.profiles_data enable row level security;

drop policy if exists "Users can read their own Athlete OS data" on public.profiles_data;
drop policy if exists "Users can insert their own Athlete OS data" on public.profiles_data;
drop policy if exists "Users can update their own Athlete OS data" on public.profiles_data;
drop policy if exists "Users can delete their own Athlete OS data" on public.profiles_data;

create policy "Users can read their own Athlete OS data"
on public.profiles_data
for select
to authenticated
using ((select auth.uid()) = user_id);

create policy "Users can insert their own Athlete OS data"
on public.profiles_data
for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "Users can update their own Athlete OS data"
on public.profiles_data
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "Users can delete their own Athlete OS data"
on public.profiles_data
for delete
to authenticated
using ((select auth.uid()) = user_id);