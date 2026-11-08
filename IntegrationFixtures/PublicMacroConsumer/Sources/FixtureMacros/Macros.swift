import FixtureOptionsModels

@attached(member, names: named(_fixtureItems), named(fixtureItems), named(init(seed:)))
public macro FixtureMembers(options: FixtureOptions) = #externalMacro(module: "FixturePlugin", type: "FixtureMembersMacro")
