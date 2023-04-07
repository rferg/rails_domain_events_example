# Handling side effects with domain events

## Side effects

- Things that happen after/as a result of a domain change
  - "When a rental application is submitted, create a credit report request"
  - "When a new record is created, update the ElasticSearch index"
  - "When a claim is submitted, send an email to the claims adjusters"
- Operational definition (?): Code that runs in response to a domain change outside the module of that change.
  - 'module' is purposefully vague (i.e., could be DDD Aggregates or more informal modules)

### Considerations for code

- Is it clear what is a side effect and what is the main operation?
- Does side effect code actually respect module boundaries or violate them?
- Should side effect code be in the same transaction or not?
- Should side effect code be async?
- Is the control flow easy to follow?

### Strategies

- Call side effects from model in operation-specific method or ActiveRecord callback
- Call side effects in Service Object or Controller method
- Models emit domain events; event handlers implement side effects
