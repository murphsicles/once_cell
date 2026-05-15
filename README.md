# @core/once_cell — Single Assignment Cells & Lazy Values

Zero-overhead atomics via direct LLVM intrinsic calls. No std dependency.

## Quick Start

```zeta
use zorb @core/once_cell::sync::OnceCell;
use zorb @core/once_cell::sync::Lazy;

// Global with lazy initialization
static CONFIG: OnceCell<Config> = OnceCell::new();
fn get_config() -> &'static Config {
    CONFIG.get_or_init(|| Config::load())
}

// Lazy static — clean and simple
static DATA: Lazy<HashMap<String, Vec<u8>>> = Lazy::new(|| {
    load_big_dataset()
});
```

## Modules

| Module | Type | Thread-safe | Blocks |
|--------|------|-------------|--------|
| `unsync` | `OnceCell<T>` | ❌ | ❌ |
| `unsync` | `Lazy<T, F>` | ❌ | ❌ |
| `sync` | `OnceCell<T>` | ✅ | ✅ (on init) |
| `sync` | `Lazy<T, F>` | ✅ | ✅ (on init) |
| `race` | `OnceNonZeroUsize` | ✅ (CAS) | ❌ |
| `race` | `OnceBool` | ✅ (CAS) | ❌ |
| `race` | `OnceRef<'a, T>` | ✅ (CAS) | ❌ |
| `race` | `OnceBox<T>` | ✅ (CAS) | ❌ |

## API

### `unsync::OnceCell<T>` / `sync::OnceCell<T>`

| Method | Returns | Description |
|--------|---------|-------------|
| `new()` | `Self` | Empty cell |
| `with_value(T)` | `Self` | Pre-initialized cell |
| `get()` | `Option<&T>` | Read if initialized |
| `get_mut()` | `Option<&mut T>` | Mutable reference |
| `set(T)` | `Result<(), T>` | Write once |
| `try_insert(T)` | `Result<&T, (&T, T)>` | Write + read |
| `get_or_init(F)` | `&T` | Lazy init (infallible) |
| `get_or_try_init(F)` | `Result<&T, E>` | Fallible lazy init |
| `take()` | `Option<T>` | Consume value |
| `into_inner()` | `Option<T>` | Consume cell |
| `is_initialized()` | `bool` | Check state (sync only) |
| `wait()` | `&T` | Block until init (sync only) |

### `unsync::Lazy<T, F>` / `sync::Lazy<T, F>`

| Method | Returns | Description |
|--------|---------|-------------|
| `new(F)` | `Self` | Create with initializer |
| `force(&self)` | `&T` | Evaluate (Deref does this) |
| `force_mut(&mut self)` | `&mut T` | Mutable evaluate |
| `get(&self)` | `Option<&T>` | Peek |
| `get_mut(&mut self)` | `Option<&mut T>` | Mutable peek |
| `into_value(Self)` | `Result<T, F>` | Consume |

### `race::*` Types

All provide `new()`, `get()`, `set()`, `get_or_init(F)`, `get_or_try_init(F, E)`.
No blocking. Multiple threads may run `F`, but only one result wins.

## Performance

- **`sync::OnceCell::get()`** — 1 atomic Acquire load
- **`sync::OnceCell::get_or_init()`** — CAS + spin/yield on contention
- **`unsync::OnceCell::get()`** — raw pointer read (zero atomics)
- **`sync::Lazy`** — first access does `get_or_init`, subsequent = Acquire load

No unnecessary allocations. No dynamic dispatch.

## License

MIT
