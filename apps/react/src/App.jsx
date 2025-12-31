import React from 'react'
import './App.css'

function App() {
  return (
    <div className="app">
      <main className="main">
        <section className="poc-info">
          <div className="container">
            <div className="poc-banner">
              <div className="poc-icon">🧪</div>
              <div className="poc-content">
                <h3 className="poc-title">Proof of Concept</h3>
                <p className="poc-description">
                  Esta aplicação foi criada como <strong>POC (Proof of Concept)</strong> para validar 
                  estratégias de deploy no CloudFront, incluindo blue-green deployment, pipeline CI/CD 
                  automatizado e infraestrutura como código com Terraform.
                </p>
              </div>
            </div>
          </div>
        </section>
      </main>
    </div>
  )
}

export default App
