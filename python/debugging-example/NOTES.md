# Debugging notes: the mutable-default-argument bug

## The bug (original code)

```python
def add_item(price, items=[]):   # <-- BUG HERE
    items.append(price)
    return items
```

## What went wrong

In Python, default argument values are evaluated **once**, when the function
is *defined* — not on each call. So `items=[]` created a single list object
that was shared by every call that didn't pass `items` explicitly.

Symptom: the second customer's order total included the first customer's
items (`60.48` instead of `34.99`). Each new "empty" order silently inherited
everything added before — a classic data-leak bug.

## The fix

```python
def add_item(price, items=None):
    if items is None:
        items = []
    items.append(price)
    return items
```

Use an immutable sentinel (`None`) as the default and build a fresh list
inside the function body. Now every call without an explicit list gets its
own independent list.

## Takeaway

Never use a mutable object (`[]`, `{}`, `set()`) as a default argument value.
This is one of the most common Python gotchas, and linters like
`pylint`/`ruff` flag it (`B006`).
