-- =============================================================================
-- SCHEMA: Bảng, trigger, RLS. Chạy trong Supabase Dashboard → SQL Editor.
-- Sau đó chạy scripts.sql để tạo RPC. Dự án mới: schema.sql → scripts.sql → seed.sql (tùy chọn).
-- =============================================================================

-- ---------- 1. DROP (theo thứ tự phụ thuộc FK) ----------
drop table if exists public.transaction_tags cascade;
drop table if exists public.transactions cascade;
drop table if exists public.group_invitations cascade;
drop table if exists public.group_members cascade;
drop table if exists public.groups cascade;
drop table if exists public.tags cascade;
drop table if exists public.debts_loans cascade;
drop table if exists public.recurring_transactions cascade;
drop table if exists public.budgets cascade;
drop table if exists public.categories cascade;
drop table if exists public.accounts cascade;
drop table if exists public.users cascade;

-- ---------- 2. USERS ----------
create table public.users (
  id uuid references auth.users on delete cascade primary key,
  username text unique,
  full_name text,
  avatar_url text,
  is_premium boolean default false,
  role text check (role in ('admin', 'user')) default 'user',
  status text check (status in ('active', 'deleted')) default 'active',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- ---------- 3. GROUPS ----------
create table public.groups (
  id uuid default uuid_generate_v4() primary key,
  name text not null,
  is_personal boolean not null default false,
  status text check (status in ('active', 'deleted')) default 'active',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- ---------- 4. GROUP_MEMBERS ----------
create table public.group_members (
  id uuid default uuid_generate_v4() primary key,
  group_id uuid references public.groups(id) on delete cascade not null,
  user_id uuid references public.users(id) on delete cascade not null,
  role text check (role in ('admin', 'member')) not null default 'member',
  status text check (status in ('active', 'left', 'deleted')) default 'active',
  joined_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(group_id, user_id)
);

-- ---------- 4b. GROUP_INVITATIONS ----------
create table public.group_invitations (
  id uuid default uuid_generate_v4() primary key,
  group_id uuid references public.groups(id) on delete cascade not null,
  user_id uuid references public.users(id) on delete cascade not null,
  invited_by uuid references public.users(id) on delete cascade not null,
  status text check (status in ('pending', 'accepted', 'declined')) default 'pending',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(group_id, user_id)
);

-- ---------- 5. ACCOUNTS ----------
create table public.accounts (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.users(id) on delete cascade not null,
  name text not null,
  account_type text check (account_type in ('asset', 'liability')) not null default 'asset',
  balance numeric default 0 not null,
  credit_limit numeric default 0,
  statement_date integer check (statement_date between 1 and 31),
  payment_date integer check (payment_date between 1 and 31),
  include_in_total boolean default true,
  currency text default 'VND' not null,
  status text check (status in ('active', 'deleted')) default 'active',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- ---------- 6. CATEGORIES ----------
create table public.categories (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.users(id) on delete cascade,
  parent_id uuid references public.categories(id) on delete cascade,
  name text not null,
  type text check (type in ('income', 'expense')) not null,
  icon_name text not null,
  color_hex text not null,
  is_default boolean default false,
  order_index integer default 0,
  is_active boolean default true,
  status text check (status in ('active', 'deleted')) default 'active',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- ---------- 7. TRANSACTIONS ----------
create table public.transactions (
  id uuid default uuid_generate_v4() primary key,
  group_id uuid references public.groups(id) on delete cascade not null,
  account_id uuid references public.accounts(id) on delete cascade not null,
  to_account_id uuid references public.accounts(id) on delete cascade,
  category_id uuid references public.categories(id) on delete set null,
  type text check (type in ('income', 'expense', 'transfer')) not null,
  amount numeric not null check (amount > 0),
  fee_amount numeric default 0 check (fee_amount >= 0),
  transaction_date timestamp with time zone not null,
  note text,
  image_url text,
  payee text,
  status text check (status in ('cleared', 'pending')) default 'cleared',
  row_status text check (row_status in ('active', 'deleted')) default 'active',
  created_by uuid references public.users(id) on delete set null not null,
  paid_by uuid references public.users(id) on delete set null not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- ---------- 8. TAGS ----------
create table public.tags (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.users(id) on delete cascade not null,
  name text not null,
  color_hex text not null,
  status text check (status in ('active', 'deleted')) default 'active',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- ---------- 9. TRANSACTION_TAGS ----------
create table public.transaction_tags (
  transaction_id uuid references public.transactions(id) on delete cascade,
  tag_id uuid references public.tags(id) on delete cascade,
  primary key (transaction_id, tag_id)
);

-- ---------- 10. BUDGETS ----------
create table public.budgets (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.users(id) on delete cascade not null,
  category_id uuid references public.categories(id) on delete cascade not null,
  amount numeric not null check (amount > 0),
  period text check (period in ('weekly', 'monthly', 'yearly', 'custom')) not null,
  start_date date not null,
  end_date date not null,
  status text check (status in ('active', 'deleted')) default 'active',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- ---------- 11. RECURRING_TRANSACTIONS ----------
create table public.recurring_transactions (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.users(id) on delete cascade not null,
  account_id uuid references public.accounts(id) on delete cascade not null,
  category_id uuid references public.categories(id) on delete set null,
  type text check (type in ('income', 'expense')) not null,
  amount numeric not null check (amount > 0),
  note text,
  frequency text check (frequency in ('daily', 'weekly', 'monthly', 'yearly')) not null,
  next_date date not null,
  is_active boolean default true,
  status text check (status in ('active', 'deleted')) default 'active',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- ---------- 12. DEBTS_LOANS ----------
create table public.debts_loans (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.users(id) on delete cascade not null,
  person_name text not null,
  type text check (type in ('debt', 'loan')) not null,
  amount numeric not null check (amount > 0),
  remaining_amount numeric not null check (remaining_amount >= 0),
  due_date date,
  status text check (status in ('active', 'paid')) default 'active',
  row_status text check (row_status in ('active', 'deleted')) default 'active',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- ---------- 13. TRIGGER: Cập nhật số dư ví ----------
create or replace function update_account_balance()
returns trigger as $$
begin
  if tg_op = 'INSERT' then
    if new.type = 'expense' then
      update public.accounts set balance = balance - new.amount where id = new.account_id;
    elsif new.type = 'income' then
      update public.accounts set balance = balance + new.amount where id = new.account_id;
    elsif new.type = 'transfer' then
      update public.accounts set balance = balance - (new.amount + new.fee_amount) where id = new.account_id;
      if new.to_account_id is not null then
        update public.accounts set balance = balance + new.amount where id = new.to_account_id;
      end if;
    end if;
    return new;
  end if;
  if tg_op = 'DELETE' then
    if old.type = 'expense' then
      update public.accounts set balance = balance + old.amount where id = old.account_id;
    elsif old.type = 'income' then
      update public.accounts set balance = balance - old.amount where id = old.account_id;
    elsif old.type = 'transfer' then
      update public.accounts set balance = balance + (old.amount + old.fee_amount) where id = old.account_id;
      if old.to_account_id is not null then
        update public.accounts set balance = balance - old.amount where id = old.to_account_id;
      end if;
    end if;
    return old;
  end if;
  return null;
end;
$$ language plpgsql security definer;

drop trigger if exists on_transaction_inserted on public.transactions;
create trigger on_transaction_inserted
  after insert on public.transactions
  for each row execute function update_account_balance();

drop trigger if exists on_transaction_deleted on public.transactions;
create trigger on_transaction_deleted
  after delete on public.transactions
  for each row execute function update_account_balance();

-- ---------- 14. TRIGGER: Đăng ký -> users + nhóm cá nhân + ví mặc định ----------
create or replace function public.handle_new_user()
returns trigger as $$
declare
  personal_group_id uuid;
begin
  insert into public.users (id, full_name, avatar_url, username, role, status)
  values (
    new.id,
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'avatar_url',
    coalesce(new.raw_user_meta_data->>'username', 'user_' || left(new.id::text, 8)),
    'user',
    'active'
  );

  insert into public.groups (name, is_personal, status)
  values ('Chi tiêu cá nhân', true, 'active')
  returning id into personal_group_id;

  insert into public.group_members (group_id, user_id, role, status)
  values (personal_group_id, new.id, 'admin', 'active');

  insert into public.accounts (user_id, name, account_type, balance, currency, status)
  values
    (new.id, 'Tiền mặt', 'asset', 0, 'VND', 'active'),
    (new.id, 'Tài khoản Ngân hàng', 'asset', 0, 'VND', 'active');

  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ---------- 15. RLS: users ----------
alter table public.users enable row level security;
drop policy if exists "Users can view own profile" on public.users;
create policy "Users can view own profile" on public.users for select using (auth.uid() = id);
drop policy if exists "Users can update own profile" on public.users;
create policy "Users can update own profile" on public.users for update using (auth.uid() = id);

-- ---------- 16. RLS: groups ----------
alter table public.groups enable row level security;
drop policy if exists "Users can view groups they belong to" on public.groups;
create policy "Users can view groups they belong to"
  on public.groups for select
  using (exists (select 1 from public.group_members gm where gm.group_id = id and gm.user_id = auth.uid() and gm.status = 'active'));
drop policy if exists "Users can insert groups" on public.groups;
create policy "Users can insert groups" on public.groups for insert with check (true);
drop policy if exists "Admins can update own group" on public.groups;
create policy "Admins can update own group"
  on public.groups for update
  using (exists (select 1 from public.group_members gm where gm.group_id = id and gm.user_id = auth.uid() and gm.role = 'admin' and gm.status = 'active'));

-- ---------- 17. RLS: group_members ----------
alter table public.group_members enable row level security;
drop policy if exists "Users can view own memberships" on public.group_members;
create policy "Users can view own memberships"
  on public.group_members for select using (user_id = auth.uid());
drop policy if exists "Users can view members of their groups" on public.group_members;
drop policy if exists "Users can join group (self)" on public.group_members;
create policy "Users can join group (self)"
  on public.group_members for insert with check (user_id = auth.uid());
drop policy if exists "Admins can insert members" on public.group_members;
create policy "Admins can insert members"
  on public.group_members for insert
  with check (exists (select 1 from public.group_members gm where gm.group_id = group_members.group_id and gm.user_id = auth.uid() and gm.role = 'admin' and gm.status = 'active'));
drop policy if exists "Admins can update members" on public.group_members;
create policy "Admins can update members"
  on public.group_members for update
  using (exists (select 1 from public.group_members gm where gm.group_id = group_members.group_id and gm.user_id = auth.uid() and gm.role = 'admin'));

alter table public.group_invitations enable row level security;
drop policy if exists "Users can view own invitations" on public.group_invitations;
create policy "Users can view own invitations"
  on public.group_invitations for select using (user_id = auth.uid());
drop policy if exists "Admins can insert invitations" on public.group_invitations;
create policy "Admins can insert invitations"
  on public.group_invitations for insert with check (invited_by = auth.uid());
drop policy if exists "Users can update own invitations" on public.group_invitations;
create policy "Users can update own invitations"
  on public.group_invitations for update using (user_id = auth.uid());

-- ---------- 18. RLS: accounts ----------
alter table public.accounts enable row level security;
drop policy if exists "Users can manage own accounts" on public.accounts;
create policy "Users can manage own accounts" on public.accounts for all using (auth.uid() = user_id);

-- ---------- 19. RLS: categories ----------
alter table public.categories enable row level security;
drop policy if exists "Users can view categories" on public.categories;
create policy "Users can view categories"
  on public.categories for select
  using ((user_id is null or auth.uid() = user_id) and (status is null or status = 'active') and is_active = true);
drop policy if exists "Users can manage own categories" on public.categories;
create policy "Users can manage own categories" on public.categories for all using (auth.uid() = user_id);

-- ---------- 20. RLS: transactions ----------
alter table public.transactions enable row level security;
drop policy if exists "Users can view group transactions" on public.transactions;
drop policy if exists "Users can insert group transactions" on public.transactions;
drop policy if exists "Users can update group transactions" on public.transactions;
drop policy if exists "Users can delete group transactions" on public.transactions;
create policy "Users can view group transactions"
  on public.transactions for select
  using (exists (select 1 from public.group_members gm where gm.group_id = transactions.group_id and gm.user_id = auth.uid() and gm.status = 'active') and (row_status is null or row_status = 'active'));
create policy "Users can insert group transactions"
  on public.transactions for insert
  with check (exists (select 1 from public.group_members gm where gm.group_id = transactions.group_id and gm.user_id = auth.uid() and gm.status = 'active'));
create policy "Users can update group transactions"
  on public.transactions for update
  using (exists (select 1 from public.group_members gm where gm.group_id = transactions.group_id and gm.user_id = auth.uid() and gm.status = 'active'));
create policy "Users can delete group transactions"
  on public.transactions for delete
  using (exists (select 1 from public.group_members gm where gm.group_id = transactions.group_id and gm.user_id = auth.uid() and gm.status = 'active'));

-- ---------- 21. RLS: tags, budgets, recurring, debts_loans, transaction_tags ----------
alter table public.tags enable row level security;
drop policy if exists "Users can manage own tags" on public.tags;
create policy "Users can manage own tags" on public.tags for all using (auth.uid() = user_id);

alter table public.budgets enable row level security;
drop policy if exists "Users can manage own budgets" on public.budgets;
create policy "Users can manage own budgets" on public.budgets for all using (auth.uid() = user_id);

alter table public.recurring_transactions enable row level security;
drop policy if exists "Users can manage own recurring" on public.recurring_transactions;
create policy "Users can manage own recurring" on public.recurring_transactions for all using (auth.uid() = user_id);

alter table public.debts_loans enable row level security;
drop policy if exists "Users can manage own debts" on public.debts_loans;
create policy "Users can manage own debts" on public.debts_loans for all using (auth.uid() = user_id);

alter table public.transaction_tags enable row level security;
drop policy if exists "Users can manage transaction_tags" on public.transaction_tags;
create policy "Users can manage transaction_tags" on public.transaction_tags for all
  using (exists (select 1 from public.transactions t join public.group_members gm on gm.group_id = t.group_id and gm.user_id = auth.uid() and gm.status = 'active' where t.id = transaction_id));
