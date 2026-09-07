/**
 * Sample TSX file for testing `gk` hover (vim.lsp.buf.hover via vtsls).
 *
 * How to test:
 *  1. `nvim sample.tsx`
 *  2. `<leader>ls` -> expect vtsls attached (plus emmet_ls, tailwindcss)
 *  3. Move cursor onto a symbol below and press `gk` (or `<leader>h`).
 *     Each section is labelled with what hover SHOULD show.
 *
 * NOTE: No tsconfig/package.json here, so vtsls runs in single-file mode —
 * local symbols hover fine, but `react`/`useState` imports won't resolve
 * types without node_modules. Use /tmp/tsx-hover-test for full React hover.
 */

import React, { useState, useEffect, useCallback, useMemo } from "react";

// ─── 1. Hover on imported bindings ───────────────────────────────────────────
// gk on `useState`, `useEffect`, `React` -> vtsls lib hover w/ docs + signature
// gk on `NON_EXISTENT` -> no hover (or error), good negative test
export type Status = "idle" | "loading" | "success" | "error";

// ─── 2. Hover on interface + properties ──────────────────────────────────────
// gk on `User`, `UserProfileProps`, `onSelect`, `isActive`
export interface User {
  /** Unique user id — hover should show this JSDoc. */
  id: string;
  displayName: string;
  email?: string;
  roles: Status[];
}

interface UserProfileProps {
  user: User;
  /** gk here should show `boolean` + JSDoc. */
  isActive: boolean;
  onSelect: (id: string) => void;
}

// ─── 3. Hover on function with JSDoc + generics ──────────────────────────────
/**
 * Formats a display name. Hover should render this docstring.
 * @param name raw display name
 * @param maxLength truncate after this many chars
 */
export function formatDisplayName<T extends string>(name: T, maxLength = 20): string {
  if (name.length > maxLength) {
    return name.slice(0, maxLength) + "…";
  }
  return name;
}

// Hover on generic utility type + mapped type
export type Nullable<T> = T | null | undefined;
export type UserMap = Record<string, Nullable<User>>;

// ─── 4. Hover on React component + JSX props ─────────────────────────────────
// gk on `UserProfile`, `props`, `user`, `isActive`, `onSelect`
export function UserProfile(props: UserProfileProps): JSX.Element {
  const { user, isActive, onSelect } = props;

  // gk on `count`, `setCount` -> useState overload hover
  const [count, setCount] = useState<number>(0);

  // gk on `doubled` -> inferred type hover (`number`)
  const doubled = useMemo(() => count * 2, [count]);

  // gk on `handleClick` -> function signature hover
  const handleClick = useCallback(() => {
    setCount((c) => c + 1);
    onSelect(user.id);
  }, [onSelect, user.id]);

  // gk on `useEffect` -> effect overload docs
  useEffect(() => {
    document.title = `Count: ${count}`;
    return () => {
      document.title = "tsx-hover-test";
    };
  }, [count]);

  return (
    <div className={isActive ? "active" : "inactive"}>
      {/* gk on `formatDisplayName` inside JSX -> function hover */}
      <h1>{formatDisplayName(user.displayName)}</h1>
      {/* gk on `user.email` -> `string | undefined` hover */}
      <p>{user.email ?? "no email"}</p>
      <p>
        Count: {count} (x2 = {doubled})
      </p>
      {/* gk on `onClick`, `handleClick`, `disabled` -> prop type hover */}
      <button onClick={handleClick} disabled={!isActive} type="button">
        Select {user.id}
      </button>
    </div>
  );
}

// ─── 5. Hover on class + methods ─────────────────────────────────────────────
export class CounterStore {
  private value = 0;

  /** gk should show `() => number` + this doc. */
  getValue(): number {
    return this.value;
  }

  increment(by = 1): void {
    this.value += by;
  }
}

// ─── 6. Hover on enum + union narrowing ──────────────────────────────────────
export enum Role {
  Admin = "ADMIN",
  Viewer = "VIEWER",
}

export function describeStatus(s: Status): string {
  // gk on `s` in each branch -> narrowed literal type hover
  switch (s) {
    case "loading":
      return "loading…";
    case "success":
      return "done!";
    case "error":
      return "failed";
    default:
      return "idle";
  }
}

// ─── 7. Hover on default export + JSX usage ──────────────────────────────────
export default function App(): JSX.Element {
  const demoUser: User = {
    id: "u_123",
    displayName: "Ada Lovelace",
    roles: ["idle", "success"],
  };

  // gk on `store`, `CounterStore`, `getValue`
  const store = new CounterStore();
  store.increment(2);
  const current = store.getValue();

  return (
    <main>
      {/* gk on `UserProfile`, `user`, `isActive`, `onSelect` props */}
      <UserProfile user={demoUser} isActive={true} onSelect={(id) => console.log(id)} />
      <footer>store value: {current}</footer>
    </main>
  );
}