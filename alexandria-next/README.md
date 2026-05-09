# Alexandria Next Plugin Package

This package contains the side-by-side Alexandria Next plugin payload.

Alexandria Next starts with `ax-next-start`: a project bootstrap entry point
that detects whether Alexandria is configured for the current project. The
plugin owns guided play behavior. Durable product docs and viewer content live
in separate packages and can be bundled into this payload during release once
that packaging path is defined.

This package must not replace or mutate `packages/alexandria-plugin` while the
Next line is being proven.
