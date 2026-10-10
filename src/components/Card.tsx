import type { HTMLAttributes } from "react";

type CardProps = HTMLAttributes<HTMLElement> & {
  title?: string;
  eyebrow?: string;
};

export function Card({
  title,
  eyebrow,
  children,
  className = "",
  ...props
}: CardProps) {
  return (
    <section
      className={`rounded-2xl border border-line bg-surface p-5 shadow-panel ${className}`}
      {...props}
    >
      {eyebrow && (
        <p className="mb-2 text-xs font-semibold uppercase tracking-[0.18em] text-accent">
          {eyebrow}
        </p>
      )}
      {title && (
        <h2 className="mb-4 text-lg font-semibold text-ink">{title}</h2>
      )}
      {children}
    </section>
  );
}
