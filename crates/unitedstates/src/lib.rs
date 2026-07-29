#![no_std]
#![forbid(unsafe_code)]
#![doc = "Facade for independently publishable U.S. public API crates."]

/// Shared transport-neutral contracts.
pub use unitedstates_core as core;

#[cfg(test)]
mod tests {
    #[test]
    fn facade_always_exposes_core() {
        let id = crate::core::SourceId::reviewed("unitedstates");
        assert_eq!(id.as_str(), "unitedstates");
    }
}
