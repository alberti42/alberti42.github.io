---
title: "Rabi oscillations, and why the detuning shortens the period"
author: ["Andrea Alberti"]
description: "A two-level atom driven near resonance, and the generalised Rabi frequency."
date: 2026-08-29T00:00:00+02:00
tags: ["two-level-systems", "rabi", "quantum-optics"]
draft: false
---

A two-level atom driven by a near-resonant field is the first thing anyone
meets in quantum optics, and the one whose algebra I keep re-deriving. This
note exists so I stop doing that.


## The Hamiltonian {#the-hamiltonian}

In the rotating frame, and after the rotating-wave approximation, the
Hamiltonian of a two-level atom driven at detuning \(\delta = \omega_L -
\omega_0\) is

\[
H = \frac{\hbar}{2}
\begin{pmatrix}
-\delta & \Omega \\
\Omega  & \delta
\end{pmatrix},
\]

with \(\Omega\) the resonant Rabi frequency, set by the dipole matrix element
and the field amplitude.


## Populations {#populations}

Starting from the ground state, the excited-state population follows

\[
P_e(t) = \frac{\Omega^2}{\Omega^2 + \delta^2}\,
         \sin^2\!\left(\frac{\tilde{\Omega} t}{2}\right),
\qquad
\tilde{\Omega} = \sqrt{\Omega^2 + \delta^2}.
\]

Two things fall out of this immediately:

1.  The oscillation **amplitude** is \(\Omega^2/\tilde{\Omega}^2\), so off
    resonance you never reach the excited state completely.
2.  The oscillation **frequency** is \(\tilde{\Omega} \geq \Omega\) — detuning
    makes the oscillation faster, not slower.

The second point is the one that trips people up. Intuitively "off resonance"
sounds like it should be sluggish, but the generalised Rabi frequency
\(\tilde{\Omega}\) is a quadrature sum: any detuning can only increase it. What
detuning costs you is contrast, not speed.


## On resonance {#on-resonance}

Setting \(\delta = 0\) recovers the familiar full-contrast result,

\[
P_e(t) = \sin^2\!\left(\frac{\Omega t}{2}\right),
\]

so a \(\pi\)-pulse takes time \(t = \pi/\Omega\).
