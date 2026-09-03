// Developed by Marcelo Glasberg (2026) https://glasberg.dev and https://github.com/marcglasberg
// For more info, see: https://pub.dartlang.org/packages/i18n_extension

/// The gender to pass to the `localizeGender` function, which selects the version
/// created with the `.male()`, `.female()` or `.neutral()` string modifiers.
///
/// For example:
///
/// ```
/// static var _t = Translations.byText("en-US") +
/// {
/// "en-US": "There is a person"
///     .male("There is a man")
///     .female("There is a woman"),
/// "pt-BR": "Há uma pessoa"
///     .male("Há um homem")
///     .female("Há uma mulher"),
/// };
///
/// String gender(Gender gender) => localizeGender(gender, this, _t);
/// ```
///
/// Then: `"There is a person".gender(Gender.female)` returns `"There is a woman"`.
///
/// A gender without a version falls back to the unversioned text. In the example above,
/// `"There is a person".gender(Gender.neutral)` returns `"There is a person"`.
///
/// This enum is visible from both [i18_exception] and [i18_exception_core] packages.
///
enum Gender { male, female, neutral }
