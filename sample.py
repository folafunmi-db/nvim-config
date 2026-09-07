"""
Sample Python file for testing `gk` hover and `gr` references
(vim.lsp.buf.hover / vim.lsp.buf.references via basedpyright).

How to test:
  1. `nvim sample.py`
  2. `<leader>ls` -> expect basedpyright attached (plus any other
     servers matching this file — basedpyright is the Python LSP)
  3. Move cursor onto a symbol below and press:
       `gk` or `<leader>h` -> hover (signature, docs, inferred type)
       `gr`              -> references (all usages of the symbol)
       `gd`/`gj`         -> definition, `gy` -> type definition

NOTE: stdlib types resolve even without a project, but pip-installed
packages need an active venv/conda env on PATH for full resolution.
"""

import os
import sys
from dataclasses import dataclass
from datetime import datetime
from enum import Enum
from pathlib import Path
from typing import Annotated, Callable, Generic, TypeAlias, TypeVar, Union

# ─── 1. Hover on stdlib imports ──────────────────────────────────────────────
# gk on `os`, `Path`, `datetime`, `Enum`, `Annotated` -> stdlib docs
# gk on `NON_EXISTENT` -> no hover (or error), good negative test

T = TypeVar("T")

UserId: TypeAlias = Annotated[str, "opaque user id"]


# ─── 2. Hover on dataclass + fields ──────────────────────────────────────────
# gk on `User`, `Settings`, `active`, `status` -> field + type hover
# gr on `active` -> both definition & usage highlighted
@dataclass
class User:
    """A user in the system. Hover should show this docstring."""

    user_id: UserId
    display_name: str
    email: str | None = None  # | -> union type hover: `str | None`
    active: bool = True


@dataclass
class Settings:
    max_retries: int = 3
    timeout: float = 30.0


# ─── 3. Hover on function with docstring + type hints ────────────────────────
# gk on `format_name`, `name`, `max_len` -> signature + docstring
def format_name(name: str, max_len: int = 20) -> str:
    """Format a display name. Hover should render this docstring.

    Args:
        name: raw display name
        max_len: truncate after this many chars
    """
    if len(name) > max_len:
        return name[:max_len] + "…"
    return name


def double_values(values: list[int]) -> list[int]:
    """Inferred return type."""
    return [v * 2 for v in values]


# ─── 4. References ───────────────────────────────────────────────────────────
# Press `gr` on `workflow` (def or any usage) -> all references listed.
# Section 4 + Section 6 + `main()` all reference it, so expect >= 4 hits.
def workflow(user: User, settings: Settings) -> User:
    """Process a user and return an updated copy."""
    print(f"handling {user.display_name}")
    if settings.max_retries == 0:
        print("no retries configured")
    return user


class UserService(Generic[T]):
    """Generic service. Hover on `T` -> type var docs."""

    def __init__(self, item: T) -> None:
        self.item = item

    def get(self) -> T:
        """gk on `get` -> `() -> T` signature."""
        return self.item


# ─── 5. Hover on enum + union narrowing ──────────────────────────────────────
# gk on `Role`, `Role.Moderator`, `role` in each branch
class Role(Enum):
    Admin = "ADMIN"
    Moderator = "MODERATOR"
    Viewer = "VIEWER"


def describe_role(role: Role) -> str:
    if role is Role.Admin:
        return "full access"
    elif role is Role.Moderator:
        return "edits only"
    return "read only"


def greeting(user: User | None, roles: Union[Role, str]) -> None:
    # gk on `name` here -> narrowed `str` (non-None) type
    if user is None:
        print("unknown user")
    else:
        name = user.display_name
        print(f"hello {name}")


# ─── 6. Type aliases + callables ─────────────────────────────────────────────
# gk on `Handler`, `OnUpdate`, `UserService` -> alias/callable hover
Handler: TypeAlias = Callable[[User], None]
OnUpdate: TypeAlias = Callable[[int], None]


def work(user: User, on_update: OnUpdate) -> None:
    for i in range(3):
        on_update(i)
    workflow(user, Settings())  # reference #1 to `workflow`


# ─── 7. Phonebook: more references to `workflow` + service ──────────────────
# gr on `workflow` -> should include the calls in `work()` and here (`main`)
def main() -> None:
    u = User("u_1", "Ada")
    s = UserService(u)

    fmt = format_name(u.display_name)  # reference to `format_name`
    doubled = double_values([1, 2, 3])  # reference to `double_values`

    updated = workflow(u, Settings(max_retries=2))  # reference #2
    current = s.get().display_name  # reference to `get`

    print(fmt, doubled, updated.active, current, sys.platform, os.name)
    describe_role(Role.Moderator)
    greeting(None, "guest")


if __name__ == "__main__":
    main()
